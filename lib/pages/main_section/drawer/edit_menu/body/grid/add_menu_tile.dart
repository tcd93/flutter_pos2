import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/repos/dishes/dishes.dart';
import 'package:flutter_pos/utils/ui_helpers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddMenuTile extends ConsumerWidget {
  const AddMenuTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.shortestSide;
    return Container(
      height: calculateExtent(screenWidth),
      padding: EdgeInsets.symmetric(horizontal: calculateMargin(screenWidth)),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          child: const Center(
            child: Text(
              'Long Press To +',
              textScaler: TextScaler.linear(1.2),
            ),
          ),
          onLongPress: () {
            ref.read(dishIDProvider.notifier).add('New Dish');
          },
        ),
      ),
    );
  }
}
