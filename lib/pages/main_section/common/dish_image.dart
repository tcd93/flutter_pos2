import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos/image_type.dart';
import 'package:flutter_pos/pages/data/repos/dishes/dishes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

final _logger = Logger('Dish Image');

class DishImage extends ConsumerWidget {
  final int dishID;

  final VoidCallback? onTap;
  final IconData? cornerIcon;
  final Widget? center;
  final BoxFit fit;

  /// Simulate FadeTransition
  final Animation<double>? opacityAnimation;

  /// Opacity applied to [Image]
  final double fixedOpacity;
  final double padding;
  final int? preferredHeight;
  final int? preferredWidth;

  const DishImage(
    this.dishID, {
    this.cornerIcon,
    this.center,
    this.onTap,
    this.fit = BoxFit.fitHeight,
    this.fixedOpacity = 1.0,
    this.opacityAnimation,
    this.padding = 8.0,
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
          opacity: opacityAnimation,
          // use BlendMode modulate and color white with opacity to optimize perf
          colorBlendMode: BlendMode.modulate,
          color: Color.fromRGBO(255, 255, 255, fixedOpacity),
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            return _wrapper(context, child);
          },
        ),
      ImageType.bytes => Image.memory(
          Uint8List.fromList(dish.imageData!),
          fit: fit,
          cacheHeight: preferredHeight,
          cacheWidth: preferredWidth,
          errorBuilder: _imageErrorBuilder,
          opacity: opacityAnimation,
          colorBlendMode: BlendMode.modulate,
          color: Color.fromRGBO(255, 255, 255, fixedOpacity),
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            return _wrapper(context, child);
          },
        ),
      ImageType.file => Image.file(
          File(dish.imagePath!),
          fit: fit,
          cacheHeight: preferredHeight,
          cacheWidth: preferredWidth,
          errorBuilder: _imageErrorBuilder,
          opacity: opacityAnimation,
          colorBlendMode: BlendMode.modulate,
          color: Color.fromRGBO(255, 255, 255, fixedOpacity),
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            return _wrapper(context, child);
          },
        ),
      ImageType.url => Image.network(
          dish.imagePath!,
          fit: fit,
          cacheHeight: preferredHeight,
          cacheWidth: preferredWidth,
          errorBuilder: _imageErrorBuilder,
          opacity: opacityAnimation,
          colorBlendMode: BlendMode.modulate,
          color: Color.fromRGBO(255, 255, 255, fixedOpacity),
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            return _wrapper(context, child);
          },
        ),
      ImageType.blank => Image.asset(
          'assets/unavailable.png',
          semanticLabel: 'Image unavailable',
          fit: fit,
          cacheHeight: preferredHeight,
          cacheWidth: preferredWidth,
          errorBuilder: _imageErrorBuilder,
          opacity: opacityAnimation,
          colorBlendMode: BlendMode.modulate,
          color: Color.fromRGBO(255, 255, 255, fixedOpacity),
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            return _wrapper(context, child);
          },
        ),
    };
  }

  Widget _imageErrorBuilder(BuildContext context, Object error, StackTrace? _) {
    _logger.warning(error);
    return Image.asset(
      'assets/unavailable.png',
      semanticLabel: 'Image unavailable',
      fit: fit,
      cacheHeight: preferredHeight,
      cacheWidth: preferredWidth,
      errorBuilder: _imageErrorBuilder,
      opacity: opacityAnimation,
      colorBlendMode: BlendMode.modulate,
      color: Color.fromRGBO(255, 255, 255, fixedOpacity),
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        return _wrapper(context, child);
      },
    );
  }

  Widget _wrapper(BuildContext context, Widget child) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Padding(
          padding: EdgeInsets.all(padding),
          child: child,
        ),
        if (center != null) Center(child: center),
        if (onTap != null)
          // use this trick to allow inkwell ripples effect above image
          Positioned.fill(
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(onTap: onTap),
            ),
          ),
        if (cornerIcon != null)
          Align(
            // position the camera icon based on percentage
            alignment: const FractionalOffset(0.9, 0.9),
            child: Container(
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[800],
              ),
              child: Icon(cornerIcon),
            ),
          ),
      ],
    );
  }
}
