import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/ephemeral.dart';
import 'package:flutter_pos/pages/data/login/login.dart';
import 'package:flutter_pos/pages/main_section/common/dish_image.dart';
import 'package:flutter_pos/pages/main_section/drawer/edit_menu/body/form/edit_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'edit_fields.dart';

class EditSingleDishView extends ConsumerWidget {
  const EditSingleDishView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return _Form(constraints);
        },
      ),
    );
  }
}

class _Form extends ConsumerWidget {
  final BoxConstraints constraints;

  const _Form(this.constraints);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editID = ref.watch(edittingDishIDProvider);
    if (editID == null) {
      return const SizedBox();
    }
    final cred = ref.watch(loginProvider).unwrapPrevious().valueOrNull;
    if (cred == null && !kDebugMode) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.pushReplacementNamed(context, '/');
      });
      return const SizedBox();
    }

    return Column(
      children: [
        Expanded(
          child: DishImage(
            editID,
            fit: BoxFit.cover,
            preferredHeight: (constraints.maxHeight / 3).floor(),
            fixedOpacity: 0.9,
            cornerIcon: Icons.camera_alt,
            onTap: () => EditImage.showSheet(context),
          ),
        ),
        const Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: EditFields(),
          ),
        ),
      ],
    );
  }
}
