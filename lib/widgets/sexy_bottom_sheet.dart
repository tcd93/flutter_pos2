import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_pos/utils/ui_helpers.dart';

const double _iconEndSize = 110;

//this code is borrowed and then modified from https://github.com/MarcinusX/buy_ticket_design

const double _iconStartSize = 75;

class MenuButton extends StatelessWidget {
  final AnimationController controller;
  final VoidCallback onPressed;

  const MenuButton(this.controller, {super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorTransitionBG = ColorTween(
      begin: Colors.transparent,
      end: Theme.of(context).colorScheme.secondary,
    ).chain(CurveTween(curve: Curves.easeInCubic)).animate(controller);

    final colorTransitionBtn = ColorTween(
      begin: Theme.of(context).colorScheme.onBackground,
      end: Theme.of(context).colorScheme.onSecondary,
    ).chain(CurveTween(curve: Curves.easeInCubic)).animate(controller);

    final colorTransitionShadow = ColorTween(
      begin: Colors.transparent,
      end: Theme.of(context).shadowColor,
    ).chain(CurveTween(curve: Curves.easeInCubic)).animate(controller);

    final elevationTween = Tween(begin: 0.0, end: 6.0)
        .chain(CurveTween(curve: Curves.easeInCubic))
        .animate(controller);

    return Positioned(
      right: 4,
      bottom: 16,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return IconButton(
            iconSize: 28 + (elevationTween.value * 1.2),
            style: ButtonStyle(
              elevation: resolveDouble(elevationTween.value),
              backgroundColor: resolveColor(colorTransitionBG.value),
              shadowColor: resolveColor(colorTransitionShadow.value),
              overlayColor: resolveColor(Colors.transparent),
            ),
            onPressed: onPressed,
            icon: AnimatedIcon(
              icon: AnimatedIcons.menu_close,
              progress: controller,
              semanticLabel: 'Open/close',
              color: colorTransitionBtn.value,
              // color: invertInvertColorsMild(context),
            ),
          );
        },
      ),
    );
  }

  MaterialStateProperty<Color?> resolveColor(Color? value) =>
      MaterialStateProperty.resolveWith((_) => value);

  MaterialStateProperty<double> resolveDouble(value) =>
      MaterialStateProperty.resolveWith((_) => value);
}

class SexyBottomSheet extends StatefulWidget {
  final double minHeight;
  final double maxHeight;

  /// Sheet open/colapse duration in millisec
  final int animationDuration;

  final List<SexyBottomSheetItem> items;

  final ValueNotifier<int> selectedIndex;

  final void Function(bool sheetOpen)? onToggle;

  final bool barrierDismissible;

  const SexyBottomSheet({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.minHeight,
    required this.maxHeight,
    this.animationDuration = 300,
    this.onToggle,
    this.barrierDismissible = false,
  });

  @override
  State<SexyBottomSheet> createState() => _SexyBottomSheetState();
}

class SexyBottomSheetItem {
  final bool disallowSelection;
  final Key key;

  /// Display icon / leading widget
  ///
  /// [value] : 1.0 == fully open, 0.0 == fully closed
  final Widget? Function(double value)? headerBuilder;

  /// Return inner child widget
  ///
  /// [value] : 1.0 == fully open, 0.0 == fully closed
  final Widget? Function(double value) childBuilder;

  const SexyBottomSheetItem(
    this.childBuilder, {
    required this.key,
    this.disallowSelection = false,
    this.headerBuilder,
  });
}

class _SexyBottomSheetState extends State<SexyBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> curve;
  /* "view box" attributes inside InteractiveViewer */
  late TransformationController transform;

  // logical container of all widgets
  double get containerHeight =>
      lerp(widget.minHeight, widget.items.length * iconSize);
  double get containerWidth =>
      lerp(widget.items.length * iconSize, screenWidth);
  // InteractiveViewer size, should be contained within screen boundary
  // and smaller than it's container
  double get viewerHeight {
    final viewerHeight = lerp(widget.minHeight, widget.maxHeight);
    return viewerHeight < containerHeight ? viewerHeight : containerHeight;
  }

  double get viewerWidth {
    final viewerWidth = screenWidth - lerp(46.0, 0.0);
    return viewerWidth < containerWidth ? viewerWidth : containerWidth;
  }

  double get screenWidth => MediaQuery.of(context).size.width;

  double get iconSize => lerp(_iconStartSize, _iconEndSize);

  bool get sheetOpen => (controller.status == AnimationStatus.completed);

  /*InteractiveViewer's states*/
  double x = 0, y = 0, slideXPct = 0, slideYPct = 0;

  /*Creates an overlay on top when open sheet, click on that closes the sheet*/
  late final OverlayEntry overlayEntry;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (sheetOpen) {
          controller.reverse();
        }
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          // paint top border
          border: Border(
            top: BorderSide(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.15),
            ),
          ),
        ),
        child: AnimatedBuilder(
          animation: controller,
          child: MenuButton(controller, onPressed: toggleBottomSheet),
          builder: (context, menuButton) {
            return Stack(
              alignment: Alignment.bottomLeft,
              children: [
                SizedBox(
                  height: viewerHeight,
                  width: viewerWidth,
                  child: scrollableViewBox(),
                ),
                menuButton!,
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    transform.dispose();
    overlayEntry.dispose();
    super.dispose();
  }

  Widget icon(SexyBottomSheetItem item) {
    int index = widget.items.indexOf(item);
    if (index == -1) return const SizedBox();
    final child = item.headerBuilder?.call(controller.value);
    if (child == null) return const SizedBox();

    return Positioned(
      height: iconSize,
      width: iconSize,
      top: iconTopMargin(index),
      left: iconLeftMargin(index),
      child: IgnorePointer(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: child,
        ),
      ),
    );
  }

  double iconLeftMargin(int index) => lerp(index * iconSize, 0);

  double iconTopMargin(int index) => lerp(0, index * iconSize);

  /* end view box */

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.animationDuration),
    );
    curve = controller.drive(CurveTween(curve: Curves.easeInOut));

    transform = TransformationController();

    // Animation controller affects the width and height of the InteractiveViewer
    // We must adjust the translation vector so that when the
    // container expand or collapse, the position of the 'view box'
    // inside container changes accordingly so it doesn't create an
    // 'out of bound' effect.
    // Remove these listeners to see that for yourself
    controller.addStatusListener((AnimationStatus status) {
      // save the attributes once at the moment of opening sheet or closing
      if (status == AnimationStatus.forward ||
          status == AnimationStatus.reverse) {
        x = transform.value.getTranslation().x;
        y = transform.value.getTranslation().y;

        if (containerWidth - viewerWidth != 0) {
          slideXPct = x / (containerWidth - viewerWidth);
        }
        if (containerHeight - viewerHeight != 0) {
          slideYPct = y / (containerHeight - viewerHeight);
        }
      }
    });
    controller.addListener(() {
      final status = controller.status;
      // translate saved X to Y when animating
      if (status == AnimationStatus.forward ||
          status == AnimationStatus.completed) {
        transform.value.setTranslationRaw(
            0, slideXPct * (containerHeight - viewerHeight), 1);
      }
      // revert
      if (status == AnimationStatus.reverse ||
          status == AnimationStatus.dismissed) {
        transform.value.setTranslationRaw(
            slideYPct * (containerWidth - viewerWidth), 0, 1);
      }
    });

    overlayEntry = OverlayEntry(
      // opaque: true,
      maintainState: true,
      builder: (context) {
        final fullHeight = MediaQuery.of(context).size.height;
        final fullWidth = MediaQuery.of(context).size.width;
        return Align(
          alignment: Alignment.topCenter,
          child: GestureDetector(
            onTap: toggleBottomSheet,
            child: Container(
              width: fullWidth,
              height: fullHeight - widget.maxHeight,
              color: Colors.transparent,
            ),
          ),
        );
      },
    );
  }

  double lerp(double min, double max) => lerpDouble(min, max, curve.value) ?? 0;

  /// Scrollable horizontally when collapsed, vertically when expanded
  Widget scrollableViewBox() {
    return InteractiveViewer(
      transformationController: transform,
      constrained: false,
      scaleEnabled: false,
      panAxis: sheetOpen ? PanAxis.vertical : PanAxis.horizontal,
      child: Stack(
        children: <Widget>[
          SizedBox(
            width: containerWidth,
            height: containerHeight,
          ),
          for (SexyBottomSheetItem item in widget.items) tile(item),
          for (SexyBottomSheetItem item in widget.items) icon(item),
        ],
      ),
    );
  }

  Widget tile(SexyBottomSheetItem item) {
    int index = widget.items.indexOf(item);
    if (index == -1) return const SizedBox();
    final child = item.childBuilder(controller.value);
    if (child == null) return const SizedBox();

    return Positioned(
      top: iconTopMargin(index),
      left: iconLeftMargin(index),
      width: lerp(iconSize, screenWidth),
      height: iconSize,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapUp: (_) {
          if (!item.disallowSelection) widget.selectedIndex.value = index;
        },
        child: ValueListenableBuilder(
          valueListenable: widget.selectedIndex,
          builder: (context, selectedIndex, tile) {
            final selected = index == selectedIndex;

            return Container(
              margin: const EdgeInsets.all(4.0),
              decoration: selected && !item.disallowSelection
                  ? BoxDecoration(
                      border: Border.all(
                        color: isThemeCurrentlyDark(context)
                            ? Theme.of(context).primaryColorLight
                            : Theme.of(context).primaryColorDark,
                      ),
                    )
                  : null,
              child: tile,
            );
          },
          child: child,
        ),
      ),
    );
  }

  void toggleBottomSheet() {
    if (!sheetOpen) {
      controller.forward();
      if (widget.barrierDismissible) Overlay.of(context).insert(overlayEntry);
    } else {
      controller.reverse();
      if (widget.barrierDismissible) overlayEntry.remove();
    }
    widget.onToggle?.call(sheetOpen);
  }
}
