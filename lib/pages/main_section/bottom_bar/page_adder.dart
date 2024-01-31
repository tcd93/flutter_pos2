import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/login.dart';
import 'package:flutter_pos/pages/data/repos/pages/pages.dart';
import 'package:flutter_pos/widgets/sexy_bottom_sheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PageAdder extends ConsumerWidget implements SexyBottomSheetItem {
  final BuildContext context;

  const PageAdder(this.context, {super.key});

  @override
  Widget? Function(double) get childBuilder {
    return (value) {
      if (value == 0.0) return null;
      return this;
    };
  }

  @override
  bool get disallowSelection => true;

  @override
  Widget? Function(double)? get headerBuilder => null;

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
      margin: const EdgeInsets.all(15.0),
      child: DottedBorder(
        dashPattern: const [8, 4],
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            child: const Center(
              child: Text(
                'Long Press To +',
                textScaler: TextScaler.linear(1.2),
              ),
            ),
            onLongPress: () =>
                ref.read(pageIDProvider.notifier).addPage('New Page'),
          ),
        ),
      ),
    );
  }
}
