import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/db.dart';
import 'package:flutter_pos/widgets/sexy_bottom_sheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PageAdder extends ConsumerWidget implements SexyBottomSheetItem {
  const PageAdder();

  @override
  Widget get child => this;

  @override
  bool get disallowSelection => true;

  @override
  bool get hideWhenCollapsed => true;

  @override
  Widget? Function()? get imageBuilder => null;

  @override
  Key get key => ValueKey(UniqueKey());

  @override
  Future<bool> Function(BuildContext)? get onDismiss => null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loggedIn = ref.watch(loginProvider);
    if (!loggedIn) {
      return const SizedBox();
    }

    return Container(
      margin: EdgeInsets.all(15.0),
      child: DottedBorder(
        dashPattern: [8, 4],
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            child: Center(
              child:
                  Text('Long Press To +', textScaler: TextScaler.linear(1.2)),
            ),
            onLongPress: () {
              ref.read(pageIDProvider.notifier).addPage('New Page');
            },
          ),
        ),
      ),
    );
  }
}
