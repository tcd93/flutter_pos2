import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/main_section/common/dish_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditMenuDishTile extends ConsumerWidget {
  final int dishID;
  final Animation<double> animation;
  final Size size;
  final VoidCallback onTap;

  const EditMenuDishTile({
    super.key,
    required this.dishID,
    required this.animation,
    required this.size,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      padding: const EdgeInsets.all(8.0),
      child: ScaleTransition(
        scale: animation.drive(
          CurveTween(
            curve: animation.status == AnimationStatus.reverse
                ? Curves.easeIn /*removing from grid animation*/
                : Curves.bounceOut, /*creation animation*/
          ),
        ),
        child: Stack(
          children: [
            Expanded(
              flex: 3,
              child: SizedBox.expand(
                child: DishImage(
                  dishID,
                  preferredHeight: size.height.floor(),
                ),
              ),
            ),
            // use this trick to allow inkwell ripples effect above image
            Positioned.fill(
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: onTap,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
