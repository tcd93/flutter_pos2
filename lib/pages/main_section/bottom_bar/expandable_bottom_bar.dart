import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/db.dart';
import 'package:flutter_pos/pages/main_section/bottom_bar/page_adder.dart';
import 'package:flutter_pos/pages/main_section/page_view/page_tile.dart';
import 'package:flutter_pos/widgets/sexy_bottom_sheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpandableBottomBar extends ConsumerWidget {
  final ValueNotifier<int> sheetIndexNotifier;

  const ExpandableBottomBar(this.sheetIndexNotifier, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageIDs = ref.watch(pageIDProvider).value ?? [];

    return SexyBottomSheet(
      items: [
        ...pageIDs
            .map((pageID) => PageTile(context, pageID))
            .toList(growable: false),
        PageAdder(context),
      ],
      selectedIndex: sheetIndexNotifier,
    );
  }
}
