import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/login/login.dart';
import 'package:flutter_pos/pages/data/repos/pages/pages.dart';
import 'package:flutter_pos/widgets/sexy_bottom_sheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PageAdder extends ConsumerWidget implements SexyBottomSheetItem {
  final BuildContext context;

  const PageAdder(this.context, {super.key});

  @override
  Widget? Function(double) get childBuilder {
    return (value) {
      // hide this widget when its about to collapse
      if (value <= 0.4) return null;
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
  Widget build(BuildContext context, WidgetRef ref) {
    final cred = ref.watch(loginProvider).unwrapPrevious().valueOrNull;
    if (cred == null) {
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
