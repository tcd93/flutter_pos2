import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/main_section/drawer/edit_menu/edit_form.dart';
import 'package:flutter_pos/pages/main_section/drawer/edit_menu/menu_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditMenuView extends ConsumerWidget {
  const EditMenuView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageControl = PageController();

    return Scaffold(
      appBar: AppBar(),
      body: PageView(
        // disable dragging to next page manually
        physics: const NeverScrollableScrollPhysics(),
        controller: pageControl,
        children: [
          MenuList(pageControl),
          EditForm(pageControl),
        ],
      ),
    );
  }
}
