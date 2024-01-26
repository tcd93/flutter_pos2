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

  @override
  State<SliverAnimatedGridWrapper<T>> createState() =>
      _SliverAnimatedGridWrapperState<T>();
}

class _SliverAnimatedGridWrapperState<T>
    extends State<SliverAnimatedGridWrapper<T>> {
  late VoidCallback listener;

  /// snapshot of initial [itemList] on creation
  late final List<T> data;
  final _gridKey = GlobalKey<SliverAnimatedGridState>();

  @override
  void initState() {
    data = [...widget.itemList];
    listener = () {
      if (widget.filterer == null) {
        throw 'Filterer function is required if notifier is not null';
      }
      filter(widget.filterer!);
    };
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
    return SliverPadding(
      padding: widget.padding ?? EdgeInsets.zero,
      sliver: SliverAnimatedGrid(
        // required for AnimatedGrid to access it's state
        key: _gridKey,
        // the animation is created and controlled during
        // [_gridKey.currentState.insertItem]
        itemBuilder: (context, index, animation) {
          return widget.widgetBuilder(
            widget.itemList.elementAt(index),
            animation,
          );
        },
        initialItemCount: widget.itemList.length,
        gridDelegate: widget.delegate,
      ),
    );
  }

  // remove filtered items and add unfiltered items
  filter(bool Function(T item) filterer) {
    if (_gridKey.currentState == null) {
      throw 'SliverAnimatedGrid is not yet built!';
    }

    final filtered = data.where(filterer).toList(growable: false);

    widget.itemList.where((e) => !filtered.contains(e)).toList()
      .forEach(
        (toBeRemoved) {
          final index = widget.itemList.indexOf(toBeRemoved);
          widget.itemList.removeAt(index);
          _gridKey.currentState!.removeItem(
            index,
            (context, reverseAnimation) {
              return widget.widgetBuilder(toBeRemoved, reverseAnimation);
            },
            duration: Duration(milliseconds: widget.outAnimationDuration),
          );
        },
      );

    filtered.where((e) => !widget.itemList.contains(e)).toList()
      .forEach(
        (toBeAdded) {
          final index = filtered.indexOf(toBeAdded);
          widget.itemList.insert(index, toBeAdded);
          _gridKey.currentState!.insertItem(
            index,
            duration: Duration(milliseconds: widget.inAnimationDuration),
          );
        },
      );
  }
}
