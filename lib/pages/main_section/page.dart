import 'package:flutter_pos/pages/data/db.dart';
import 'package:flutter_pos/pages/main_section/drawer.dart';
import 'package:flutter_pos/pages/main_section/page_body.dart';
import 'package:flutter_pos/widgets/sexy_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Pages extends ConsumerStatefulWidget {
  @override
  createState() => _PagesState();
}

class _PagesState extends ConsumerState<Pages> {
  final sheetIndexNotifier = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    final result = ref.watch(pageIDProvider);
    return result.when(
      data: (pageIDs) {
        return Scaffold(
          body: PageBody(pageIDs, sheetIndexNotifier),
          extendBody: true, // to achieve the bottom bar rounded corners effect
          endDrawer: const PageDrawer(),
          bottomNavigationBar: SexyBottomSheet(
            items: pageIDs.map((pageID) {
              final name = ref.watch(pageNameProvider(pageID)).value;
              return Text(name ?? '');
            }).toList(growable: false),
            imageBuilder: (_) => Image.asset(
              'assets/icon/icon-legacy.png',
              fit: BoxFit.cover,
            ),
            selectedIndex: sheetIndexNotifier,
          ),
        );
      },
      error: (error, stackTrace) => Center(child: Text(error.toString())),
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }

  @override
  void dispose() {
    sheetIndexNotifier.dispose();
    super.dispose();
  }
}
