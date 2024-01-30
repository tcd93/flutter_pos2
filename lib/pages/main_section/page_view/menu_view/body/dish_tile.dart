import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/ephemeral.dart';
import 'package:flutter_pos/pages/data/repos/dishes/dishes.dart';
import 'package:flutter_pos/pages/data/repos/servings/servings.dart';
import 'package:flutter_pos/pages/main_section/common/dish_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DishTile extends ConsumerWidget {
  final int dishID;
  final Animation<double> animation;
  final Size size;

  const DishTile({
    super.key,
    required this.dishID,
    required this.animation,
    required this.size,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardID = ref.watch(selectedCardProvider);
    final portion = ref.watch(portionProvider(cardID!, dishID)).value ?? 0;
    final dish = ref.watch(dishItemProvider(dishID)).value;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      color:
          portion > 0 ? Theme.of(context).highlightColor : Colors.transparent,
      padding: const EdgeInsets.all(8.0),
      child: ScaleTransition(
        alignment: Alignment.topLeft,
        scale: animation.drive(
          CurveTween(
            curve: animation.status == AnimationStatus.reverse
                ? Curves.easeIn /*removing from grid animation*/
                : Curves.bounceOut, /*creation animation*/
          ),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => updateOrDelete(ref, portion + 1),
                // onDoubleTap: () => updateOrDelete(ref, portion - 1),
                onLongPress: () => updateOrDelete(ref, 0),
                // wrap image in a SizedBox to prevent it from blocking
                // GestureDetector while loading
                child: SizedBox.expand(
                  child: Column(
                    children: [
                      Expanded(
                        flex: 4,
                        child: DishImage(
                          dishID,
                          preferredHeight: size.height.floor(),
                          opacityAnimation: animation,
                          padding: 0.0,
                        ),
                      ),
                      Expanded(child: Text(dish?.name ?? '')),
                      Expanded(
                        child: Text(
                          dish != null ? '${dish.price.toString()}\$' : '',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(height: 8.0),
            Expanded(child: _buttonRow(ref, portion)),
          ],
        ),
      ),
    );
  }

  void updateOrDelete(WidgetRef ref, int value) {
    final cardID = ref.read(selectedCardProvider);
    ref.read(portionProvider(cardID!, dishID).notifier).updateOrDelete(value);
  }

  Row _buttonRow(WidgetRef ref, int portion) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: IconButton(
            onPressed: () => updateOrDelete(ref, portion - 1),
            icon: const Icon(Icons.arrow_back_ios_new),
            padding: EdgeInsets.zero,
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: Center(
            child: Text(portion.toString()),
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: IconButton(
            onPressed: () => updateOrDelete(ref, portion + 1),
            icon: const Icon(Icons.arrow_forward_ios),
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}
