import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pos/image_type.dart';
import 'package:flutter_pos/pages/data/ephemeral.dart';
import 'package:flutter_pos/pages/data/repos/dishes/dishes.dart';
import 'package:flutter_pos/pages/data/repos/servings/servings.dart';
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      color:
          portion > 0 ? Theme.of(context).highlightColor : Colors.transparent,
      padding: const EdgeInsets.all(8.0),
      child: ScaleTransition(
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
                  onTapDown: (_) => updateOrDelete(ref, portion + 1),
                  // onDoubleTap: () => updateOrDelete(ref, portion - 1),
                  onLongPressUp: () => updateOrDelete(ref, 0),
                  // wrap image in a SizedBox to prevent it from blocking
                  // GestureDetector while loading
                  child: SizedBox.expand(child: _imageConverter(ref)),
                )),
            const Divider(),
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

  Widget _imageConverter(WidgetRef ref) {
    final dish = ref.watch(dishItemProvider(dishID)).value;
    if (dish == null) return const Placeholder();

    return switch (dish.imageType) {
      ImageType.asset => Image.asset(
          dish.imagePath!,
          fit: BoxFit.fitHeight,
          // cacheWidth: size.width.floor(),
          cacheHeight: size.height.floor(),
          errorBuilder: _imageErrorBuilder,
        ),
      ImageType.bytes => Image.memory(
          Uint8List.fromList(dish.imageData!),
          fit: BoxFit.fitHeight,
          // cacheWidth: size.width.floor(),
          cacheHeight: size.height.floor(),
          errorBuilder: _imageErrorBuilder,
        ),
      ImageType.file => Image.file(
          File(dish.imagePath!),
          fit: BoxFit.fitHeight,
          // cacheWidth: size.width.floor(),
          cacheHeight: size.height.floor(),
          errorBuilder: _imageErrorBuilder,
        ),
      ImageType.url => Image.network(
          dish.imagePath!,
          fit: BoxFit.fitHeight,
          // cacheWidth: size.width.floor(),
          cacheHeight: size.height.floor(),
          errorBuilder: _imageErrorBuilder,
        ),
    };
  }

  Widget _imageErrorBuilder(BuildContext context, Object error, StackTrace? _) {
    return Image.asset(
      'assets/unavailable.png',
      semanticLabel: 'Image unavailable',
    );
  }
}
