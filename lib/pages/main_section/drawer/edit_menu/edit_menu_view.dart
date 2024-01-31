import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/login.dart';
import 'package:flutter_pos/pages/main_section/common/search_bar.dart';
import 'package:flutter_pos/pages/main_section/drawer/edit_menu/body/edit_form.dart';
import 'package:flutter_pos/pages/main_section/drawer/edit_menu/body/edit_menu_sliver_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditMenuView extends ConsumerWidget {
  const EditMenuView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loggedIn = ref.watch(loginProvider);
    if (!loggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.pushReplacementNamed(context, '/');
      });
      return const SizedBox();
    }

    final filterString = ValueNotifier('');
    final pageControl = PageController();

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: MySearchBar(filterString),
          ),
        ],
      ),
      body: PageView(
        // disable dragging to next page manually
        physics: const NeverScrollableScrollPhysics(),
        controller: pageControl,
        children: [
          EditMenuSliverGrid(
            pageControl: pageControl,
            filterString: filterString,
          ),
          EditForm(pageControl),
        ],
      ),
    );
  }
}
