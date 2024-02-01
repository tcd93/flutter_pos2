import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/login/login.dart';
import 'package:flutter_pos/pages/main_section/common/search_bar.dart';
import 'package:flutter_pos/pages/main_section/drawer/edit_menu/body/grid/edit_menu_sliver_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditMenuView extends ConsumerWidget {
  const EditMenuView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cred = ref.watch(loginProvider).unwrapPrevious().valueOrNull;
    if (cred == null && !kDebugMode) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.pushReplacementNamed(context, '/');
      });
      return const SizedBox();
    }

    final filterString = ValueNotifier('');

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: MySearchBar(filterString),
          ),
        ],
      ),
      body: EditMenuSliverGrid(
        filterString: filterString,
      ),
    );
  }
}
