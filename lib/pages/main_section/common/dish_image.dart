import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_pos/image_type.dart';
import 'package:flutter_pos/pages/data/repos/dishes/dishes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DishImage extends ConsumerWidget {
  final int dishID;
  final BoxFit fit;
  final int? preferredHeight;
  final int? preferredWidth;

  const DishImage(
    this.dishID, {
    this.fit = BoxFit.fitHeight,
    this.preferredHeight,
    this.preferredWidth,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dish = ref.watch(dishItemProvider(dishID)).value;
    if (dish == null) return const Placeholder();

    return switch (dish.imageType) {
      ImageType.asset => Image.asset(
          dish.imagePath!,
          fit: fit,
          // cacheWidth: size.width.floor(),
          cacheHeight: preferredHeight,
          cacheWidth: preferredWidth,
          errorBuilder: _imageErrorBuilder,
        ),
      ImageType.bytes => Image.memory(
          Uint8List.fromList(dish.imageData!),
          fit: fit,
          cacheHeight: preferredHeight,
          cacheWidth: preferredWidth,
          errorBuilder: _imageErrorBuilder,
        ),
      ImageType.file => Image.file(
          File(dish.imagePath!),
          fit: fit,
          cacheHeight: preferredHeight,
          cacheWidth: preferredWidth,
          errorBuilder: _imageErrorBuilder,
        ),
      ImageType.url => Image.network(
          dish.imagePath!,
          fit: fit,
          cacheHeight: preferredHeight,
          cacheWidth: preferredWidth,
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
