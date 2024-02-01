import 'package:flutter/rendering.dart';
import 'package:logging/logging.dart';

final _logger = Logger('Custom Grid');

/// Square grid layout except last child takes up the rest of the space
class FillLastChildGridDelegate extends SliverGridDelegate {
  FillLastChildGridDelegate({
    required this.dimension,
    required this.childCount,
  });

  final int childCount;

  /// This is the desired height of each row (and width of each square).
  /// Not the actual final size of the square
  final double dimension;

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    // Determine how many squares we can fit per row.
    int count = constraints.crossAxisExtent ~/ dimension;
    if (count < 1) {
      count = 1;
    }
    _logger.fine(
      'crossAxisExtent = ${constraints.crossAxisExtent}, dimension = $dimension => crossAxisCount = $count',
    );
    final double squareDimension = constraints.crossAxisExtent / count;
    return GridLayoutFillLastChild(
      crossAxisCount: count,
      childCount: childCount,
      dimension: squareDimension,
    );
  }

  @override
  bool shouldRelayout(FillLastChildGridDelegate oldDelegate) {
    return dimension != oldDelegate.dimension;
  }
}

class GridLayoutFillLastChild extends SliverGridLayout {
  const GridLayoutFillLastChild({
    required this.crossAxisCount,
    required this.childCount,
    required this.dimension,
  }) : assert(crossAxisCount > 0);

  final int crossAxisCount;
  final int childCount;
  final double dimension;

  @override
  double computeMaxScrollOffset(int childCount) {
    // This returns the scroll offset of the end side of the childCount'th child.

    if (childCount == 0 || dimension == 0) {
      return 0;
    }
    int numOfRows = (childCount / crossAxisCount).ceil();
    _logger.fine(
      'childCount = $childCount, crossAxisCount = $crossAxisCount => numOfRows = $numOfRows',
    );
    return numOfRows * dimension;
  }

  @override
  SliverGridGeometry getGeometryForChildIndex(int index) {
    // This returns the position of the index'th tile.

    int rowIndex = index ~/ crossAxisCount;
    int columnIndex = index % crossAxisCount;
    _logger.fine(
      'index = $index => columnIndex = $columnIndex, rowIndex = $rowIndex',
    );

    // expand the last tile to full width
    if (index == childCount - 1) {
      int remainingTiles = crossAxisCount - columnIndex;
      _logger.fine(
        'remainingTiles = $remainingTiles',
      );
      return SliverGridGeometry(
        scrollOffset: rowIndex * dimension, // "y"
        crossAxisOffset: columnIndex * dimension, // "x"
        mainAxisExtent: dimension, // "height"
        crossAxisExtent: remainingTiles * dimension, // "width"
      );
    }
    // Normal square case.
    return SliverGridGeometry(
      scrollOffset: rowIndex * dimension, // "y"
      crossAxisOffset: columnIndex * dimension, // "x"
      mainAxisExtent: dimension, // "height"
      crossAxisExtent: dimension, // "width"
    );
  }

  @override
  int getMinChildIndexForScrollOffset(double scrollOffset) {
    // This returns the first index that is visible for a given scrollOffset.
    // This is for performance optimizations.
    // If you don't care about it, just return zero.
    // [scrollOffset] is not equal to getMaxChildIndexForScrollOffset's scrollOffset
    // use the start of the scrollable area as the reference point

    _logger.fine('scrollOffset = $scrollOffset, dimension = $dimension, '
        'minChildIndex = ${scrollOffset ~/ dimension}');
    return crossAxisCount * (scrollOffset ~/ dimension);
  }

  @override
  int getMaxChildIndexForScrollOffset(double scrollOffset) {
    // This returns the last index that is visible for a given scrollOffset.
    // This is for performance optimizations.
    // If you don't care about it, just return childCount - 1;
    // [scrollOffset] is height since top.

    final int mainAxisCount = scrollOffset ~/ dimension;
    _logger.fine('scrollOffset = $scrollOffset, dimension = $dimension, '
        'maxChildIndex = ${mainAxisCount * crossAxisCount - 1}');
    return crossAxisCount * mainAxisCount - 1;
  }
}
