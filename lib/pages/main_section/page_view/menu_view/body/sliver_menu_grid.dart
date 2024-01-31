import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/repos/dishes/dishes.dart';
import 'package:flutter_pos/pages/main_section/common/loading_bar.dart';
import 'package:flutter_pos/pages/main_section/page_view/menu_view/body/dish_tile.dart';
import 'package:flutter_pos/utils/ui_helpers.dart';
import 'package:flutter_pos/widgets/sliver_grid_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SliverMenuGrid extends ConsumerWidget {
  final ValueNotifier<String> filterString;

  const SliverMenuGrid(this.filterString, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.shortestSide;
    final extent = calculateExtent(screenWidth);
    final margin = calculateMargin(screenWidth);

    final dishIDs = ref.watch(dishIDProvider).value;
    if (dishIDs == null) {
      return const SliverLoadingBar();
    }
    if (dishIDs.isEmpty) {
      return const Center(
        child: Text('Empty menu, please add some menu items at'
            ' main screen\'s setting'),
      );
    }

    return SliverAnimatedGridWrapper(
      notifier: filterString,
      filterer: (dishID) {
        final dish = ref.watch(dishItemProvider(dishID)).value!;
        return dish.name.contains(filterString.value);
      },
      itemList: dishIDs,
      widgetBuilder: (dishID, animation) {
        return DishTile(
          key: ValueKey(dishID),
          dishID: dishID,
          size: Size.square(extent),
          animation: animation,
        );
      },
      delegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: extent,
        mainAxisExtent: extent + extent * 0.4,
        crossAxisSpacing: margin / 2,
        mainAxisSpacing: margin / 2,
      ),
      padding: EdgeInsets.symmetric(horizontal: margin),
    );
  }
}
