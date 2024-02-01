import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/repos/dishes/dishes.dart';
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
    return ScaleTransition(
      alignment: Alignment.topLeft,
      scale: animation.drive(
        CurveTween(
          curve: animation.status == AnimationStatus.reverse
              ? Curves.easeIn /*removing from grid animation*/
              : Curves.bounceOut, /*creation animation*/
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        child: DishImage(
          dishID,
          preferredHeight: size.height.floor(),
          fixedOpacity: 0.4,
          opacityAnimation: animation,
          fit: BoxFit.cover,
          onTap: onTap,
          center: Consumer(
            builder: (context, ref, child) {
              final dish = ref.watch(dishItemProvider(dishID)).value;
              return Text.rich(
                textAlign: TextAlign.center,
                softWrap: true,
                TextSpan(
                  children: [
                    TextSpan(text: dish?.name ?? ''),
                    const TextSpan(text: '\n'),
                    TextSpan(
                      text: dish?.price != null
                          ? '${dish?.price.toString()}\$'
                          : '',
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
