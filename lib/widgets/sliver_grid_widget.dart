import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

/// Wrapper for [SliverAnimatedGrid] to fix its stupid APIs
class SliverAnimatedGridWrapper<T> extends StatefulWidget {
  SliverAnimatedGridWrapper({
    super.key,
    required this.widgetBuilder,
    required this.itemList,
    this.notifier,
    this.filterer,
    SliverGridDelegate? delegate,
    this.inAnimationDuration = 300,
    this.outAnimationDuration = 400,
    this.padding,
    this.keepAlive = true,
  }) {
    this.delegate = delegate ??
        const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 180,
          mainAxisSpacing: 2.0,
          crossAxisSpacing: 2.0,
        );
  }

  /// Specify how to construct the Widget from a data point in [itemList]
  ///
  /// Animation is the animating in/out values.
  ///
  /// When removing this widget from grid, animation state will be Reverse.
  final Widget Function(T data, Animation<double> animation) widgetBuilder;

  /// Data, this widget will mutate this list internally
  final List<T> itemList;

  /// Notify grid to re-arrange based on [filterer] function
  final Listenable? notifier;

  /// Triggered on each item on [itemList]
  final bool Function(T item)? filterer;

  late final SliverGridDelegate delegate;
  final int inAnimationDuration;
  final int outAnimationDuration;
  final EdgeInsets? padding;

  final bool keepAlive;

  @override
  State<SliverAnimatedGridWrapper<T>> createState() =>
      _SliverAnimatedGridWrapperState<T>();
}

class _SliverAnimatedGridWrapperState<T>
    extends State<SliverAnimatedGridWrapper<T>>
    with AutomaticKeepAliveClientMixin {
  /// snapshot of initial [itemList] on creation, this is to detect changes of [widget.itemList]
  late final List<T> data;

  /// the array to present on screen
  late final List<T> displayData;

  List<T> filteredList = [];

  /// key to access SliverAnimatedGridState's inner state
  final _gridKey = GlobalKey<SliverAnimatedGridState>();

  void listener() {
    if (widget.filterer == null) {
      throw 'Filterer function is required if notifier is not null';
    }
    filter(widget.filterer!);
  }

  @override
  void initState() {
    data = [...widget.itemList];
    displayData = [...data];
    widget.notifier?.addListener(listener);
    super.initState();
  }

  @override
  void dispose() {
    widget.notifier?.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // start item animations when widget.itemList changes
    if (widget.itemList.length > data.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // find items added to widget.itemList and not in data
        final addedItems =
            widget.itemList.where((item) => !data.contains(item));
        for (final item in addedItems) {
          data.add(item);
          displayData.add(item);
          _gridKey.currentState!.insertItem(
            displayData.length - 1,
            duration: Duration(milliseconds: widget.inAnimationDuration),
          );
        }
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // find items removed from widget.itemList and still in data
        final removedItems =
            data.where((item) => !widget.itemList.contains(item));
        for (final item in removedItems) {
          final index = data.indexOf(item);
          data.remove(item);
          displayData.remove(item);
          _gridKey.currentState!.removeItem(
            index,
            (context, animation) {
              return widget.widgetBuilder(item, animation);
            },
            duration: Duration(milliseconds: widget.outAnimationDuration),
          );
        }
      });
    }

    return SliverPadding(
      padding: widget.padding ?? EdgeInsets.zero,
      sliver: SliverAnimatedGrid(
        // required for AnimatedGrid to access it's state
        key: _gridKey,
        // the animation is created and controlled during
        // [_gridKey.currentState.insertItem]
        itemBuilder: (context, index, animation) {
          return widget.widgetBuilder(
            displayData.elementAt(index),
            animation,
          );
        },
        initialItemCount: displayData.length,
        gridDelegate: widget.delegate,
      ),
    );
  }

  // remove filtered items and add unfiltered items
  filter(bool Function(T item) filterer) {
    if (_gridKey.currentState == null) {
      throw 'SliverAnimatedGrid is not yet built!';
    }

    filteredList = widget.itemList.where(filterer).toList(growable: false);

    final displayedItemsNotInFilteredList =
        displayData.whereNot(filteredList.contains).toList();
    displayedItemsNotInFilteredList.forEach(_removeAnimated);

    final filteredItemsNotInDisplayList =
        filteredList.whereNot(displayData.contains).toList();
    filteredItemsNotInDisplayList.forEach(_addAnimated);
  }

  void _removeAnimated(T item) {
    final index = displayData.indexOf(item);

    displayData.removeAt(index);
    _gridKey.currentState!.removeItem(
      index,
      (context, reverseAnimation) {
        return widget.widgetBuilder(item, reverseAnimation);
      },
      duration: Duration(milliseconds: widget.outAnimationDuration),
    );
  }

  void _addAnimated(T item) {
    final index = filteredList.indexOf(item);

    displayData.insert(index, item);
    _gridKey.currentState!.insertItem(
      index,
      duration: Duration(milliseconds: widget.inAnimationDuration),
    );
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;
}
