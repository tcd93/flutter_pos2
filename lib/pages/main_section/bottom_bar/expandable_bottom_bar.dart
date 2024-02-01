import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/ephemeral.dart';
import 'package:flutter_pos/pages/data/repos/pages/pages.dart';
import 'package:flutter_pos/pages/main_section/bottom_bar/page_adder.dart';
import 'package:flutter_pos/pages/main_section/bottom_bar/page_tile.dart';
import 'package:flutter_pos/utils/app_theme.dart';
import 'package:flutter_pos/widgets/sexy_bottom_sheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpandableBottomBar extends ConsumerWidget {
  final ValueNotifier<int> sheetIndexNotifier;

  const ExpandableBottomBar(this.sheetIndexNotifier, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageIDs = ref.watch(pageIDProvider).value ?? [];
    final screenHeight = MediaQuery.of(context).size.height;

    return SexyBottomSheet(
      items: [
        ...pageIDs.map((pageID) => PageTile(context, pageID)),
        PageAdder(context),
      ],
      selectedIndex: sheetIndexNotifier,
      onToggle: ref.read(bottomSheetStatusProvider.notifier).set,
      minHeight: AppTheme.navBarHeight,
      maxHeight: screenHeight - AppTheme.navBarHeight,
    );
  }
}
