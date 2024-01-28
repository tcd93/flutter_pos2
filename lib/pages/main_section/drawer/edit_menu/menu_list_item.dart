import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/repos/dishes/dishes.dart';
import 'package:flutter_pos/pages/main_section/common/dish_image.dart';
import 'package:flutter_pos/utils/app_theme.dart';
import 'package:flutter_pos/utils/ui_helpers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuListItem extends ConsumerWidget {
  final int dishID;
  final PageController pageControl;

  const MenuListItem(
    this.dishID, {
    required this.pageControl,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dish = ref.watch(dishItemProvider(dishID)).value;
    if (dish == null) return const SizedBox(); // loading

    final screenHeight = MediaQuery.of(context).size.longestSide;
    final extent = calculateExtent(screenHeight);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: InkWell(
          child: Row(
            children: [
              DishImage(
                dishID,
                fit: BoxFit.contain,
                preferredHeight: extent.floor(),
                preferredWidth: extent.floor(),
              ),
              Text(dish.name),
              Text(
                dish.price.toString(),
                textScaler: const TextScaler.linear(0.75),
              ),
            ],
          ),
          onTap: () {
            pageControl.animateToPage(
              1,
              duration: const Duration(
                milliseconds: AppTheme.carouselDuration,
              ),
              curve: Curves.easeIn,
            );
          },
        ),
      ),
    );
  }
}
