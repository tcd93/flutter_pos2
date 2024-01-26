import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/db.dart';
import 'package:flutter_pos/pages/main_section/page_view/menu_view/body/dish_tile.dart';
import 'package:flutter_pos/widgets/sliver_grid_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

final _logger = Logger('Menu Grid');

class SliverMenuGrid extends ConsumerStatefulWidget {
  final ValueNotifier<String> filterString;

  const SliverMenuGrid(this.filterString, {super.key});

  @override
  ConsumerState<SliverMenuGrid> createState() => _MenuGridState();
}

class _MenuGridState extends ConsumerState<SliverMenuGrid> {
  double screenWidth = 0.0;
  double extent = 0.0;
  double margin = 0.0;

  @override
  Widget build(BuildContext context) {
    _logger.info('Menu grid build');
    final result = ref.watch(dishIDProvider);
    return result.when(
      data: (dishIDs) {
        return SliverAnimatedGridWrapper(
          notifier: widget.filterString,
          filterer: (dishID) {
            final dish = ref.watch(dishItemProvider(dishID)).value!;
            return dish.name.contains(widget.filterString.value);
          },
          itemList: dishIDs,
          widgetBuilder: (dishID, animation) {
            final dish = ref.watch(dishItemProvider(dishID)).value!;
            return DecoratedBox(
              key: ValueKey(dish),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
              child: DishTile(
                dishID: dish.id,
                type: dish.imageType,
                imageData: dish.imageData,
                imagePath: dish.imagePath,
                size: Size.square(extent),
                animation: animation,
              ),
            );
          },
          delegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: extent,
            mainAxisExtent: extent,
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screenWidth = MediaQuery.of(context).size.shortestSide;
    extent = switch (screenWidth) {
      < 600 /*phone*/ => screenWidth / 3,
      >= 600 && < 905 /*tablet*/ => screenWidth / 6,
      >= 905 && < 1240 => screenWidth / 8,
      >= 1240 && < 1440 => screenWidth / 10,
      _ => screenWidth / 12,
    };
    margin = switch (screenWidth) {
      < 600 => 16,
      >= 600 && < 905 => 32,
      >= 905 && < 1240 =>
        lerpDouble(32, 200, (screenWidth - 905) / (1240 - 905))!,
      >= 1240 && < 1440 => 200,
      _ => 232,
    };
  }
}
