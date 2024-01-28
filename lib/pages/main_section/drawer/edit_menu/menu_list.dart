import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/repos/dishes/dishes.dart';
import 'package:flutter_pos/pages/main_section/drawer/edit_menu/menu_list_item.dart';
import 'package:flutter_pos/utils/ui_helpers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

final _logger = Logger('Menu List');

// page 0

class MenuList extends ConsumerWidget {
  final PageController pageControl;

  const MenuList(this.pageControl, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = MediaQuery.of(context).size.longestSide;
    final extent = calculateExtent(screenHeight);
    final asyncData = ref.watch(dishIDProvider);

    return asyncData.when(
      data: (dishIDs) {
        return ListView.builder(
          itemBuilder: (context, index) {
            if (index >= dishIDs.length) {
              return const SizedBox();
            }
            final id = dishIDs[index];
            return MenuListItem(
              id,
              pageControl: pageControl,
              key: ValueKey(id),
            );
          },
          itemCount: dishIDs.length,
          itemExtent: extent,
          physics: const BouncingScrollPhysics(),
        );
      },
      error: (error, stackTrace) {
        _logger.severe('Error', error, stackTrace);
        return const Center(child: Text('An error occurred'));
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
