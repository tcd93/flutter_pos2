import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/repos/dishes/dishes.dart';
import 'package:flutter_pos/pages/main_section/page_view/menu_view/body/dish_tile.dart';
import 'package:flutter_pos/utils/ui_helpers.dart';
import 'package:flutter_pos/widgets/sliver_grid_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

final _logger = Logger('Menu Grid');

class SliverMenuGrid extends ConsumerWidget {
  final ValueNotifier<String> filterString;

  const SliverMenuGrid(this.filterString, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.shortestSide;
    final extent = calculateExtent(screenWidth);
    final margin = calculateMargin(screenWidth);

    final result = ref.watch(dishIDProvider);
    return result.when(
      data: (dishIDs) {
        return SliverAnimatedGridWrapper(
          notifier: filterString,
          filterer: (dishID) {
            final dish = ref.watch(dishItemProvider(dishID)).value!;
            return dish.name.contains(filterString.value);
          },
          itemList: dishIDs,
          widgetBuilder: (dishID, animation) {
            return DecoratedBox(
              key: ValueKey(dishID),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
              child: DishTile(
                dishID: dishID,
                size: Size.square(extent),
                animation: animation,
              ),
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
      },
      loading: () => const SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (e, s) => SliverToBoxAdapter(child: Text('Error: $e')),
    );
  }
}
