import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_pos/utils/ui_helpers.dart';

const double safeArea = 60;
const double _iconEndSize = 110;

//this code is borrowed and then modified from https://github.com/MarcinusX/buy_ticket_design

const double _iconStartSize = 75;

class MenuButton extends StatelessWidget {
  final AnimationController controller;
  final VoidCallback onPressed;

  final MaterialStateProperty<double> Function(double value) resolveDouble =
      (value) => MaterialStateProperty.resolveWith((_) => value);
  final MaterialStateProperty<Color?> Function(Color? value) resolveColor =
      (value) => MaterialStateProperty.resolveWith((_) => value);

  MenuButton(this.controller, {required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorTransitionBG = ColorTween(
      begin: Colors.transparent,
      end: Theme.of(context).colorScheme.secondary,
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
        builder: (context, animatedIcon) {
          return IconButton(
            iconSize: 28 + (elevationTween.value * 1.2),
            style: ButtonStyle(
              elevation: resolveDouble(elevationTween.value),
              backgroundColor: resolveColor(colorTransitionBG.value),
              shadowColor: resolveColor(colorTransitionShadow.value),
              overlayColor: resolveColor(Colors.transparent),
            ),
            onPressed: onPressed,
            icon: animatedIcon!,
          );
        },
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: controller,
          semanticLabel: 'Open/close',
          // color: invertInvertColorsMild(context),
        ),
      ),
    );
  }
}

class SexyBottomSheet extends StatefulWidget {
  static double minHeight = 80;

  final List<SexyBottomSheetItem> items;

  /// Display a row of Images in collapsed state from [items]
  final Widget? Function(int index)? imageBuilder;
  final ValueNotifier<int> selectedIndex;

  SexyBottomSheet({
    required this.items,
    required this.selectedIndex,
    this.imageBuilder,
  });

  @override
  _SexyBottomSheetState createState() => _SexyBottomSheetState();
}

class SexyBottomSheetItem {
  final Widget child;
  final bool hideWhenCollapsed;
  final bool disallowSelection;
  final Key key;

  /// Return [true] to confirm deletion; Set null to disable dismiss functionality
  final Future<bool> Function(BuildContext context)? onDismiss;

  const SexyBottomSheetItem(
    this.child, {
    required this.key,
    this.hideWhenCollapsed = false,
    this.disallowSelection = false,
    this.onDismiss,
  });
}

class _SexyBottomSheetState extends State<SexyBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  /* "view box" attributes inside InteractiveViewer */
  late TransformationController transform;

  double get containerHeight => lerp(SexyBottomSheet.minHeight, sheetSize);

  // bigger container of the view box
  double get containerWidth => lerp(sheetSize, screenWidth);

  double get iconSize => lerp(_iconStartSize, _iconEndSize);

  double get screenHeight => MediaQuery.of(context).size.height;

  double get screenWidth => MediaQuery.of(context).size.width;

  bool get sheetOpen => (controller.status == AnimationStatus.completed);

  double get sheetSize => widget.items.length * iconSize + safeArea;

  // minus the default height of bottom sheet
  double get viewerHeight => lerp(SexyBottomSheet.minHeight, screenHeight);
  double get viewerWidth => screenWidth - lerp(46.0, 0.0);
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      child: MenuButton(controller, onPressed: toggleBottomSheet),
      builder: (context, menuButton) {
        return Container(
          height: lerp(SexyBottomSheet.minHeight, screenHeight),
          child: Material(
            // follow BottomAppBar
            elevation: 3.0,
            color: Theme.of(context).colorScheme.surface,
            surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
            child: Stack(
              children: [
                scrollableViewBox(),
                menuButton!,
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    transform.dispose();
    super.dispose();
  }

  Widget icon(SexyBottomSheetItem item) {
    int index = widget.items.indexOf(item);
    if (index == -1) return SizedBox();
    if (item.hideWhenCollapsed && !sheetOpen) return SizedBox();

    return Positioned(
      height: iconSize,
      width: iconSize,
      top: iconTopMargin(index),
      left: iconLeftMargin(index),
      child: IgnorePointer(
        child: Container(
          margin: EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
            child: widget.imageBuilder?.call(index),
          ),
        ),
      ),
    );
  }

  double iconLeftMargin(int index) => lerp(index * iconSize, 0);

  double iconTopMargin(int index) => lerp(0, safeArea + index * iconSize);

  /* end view box */

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    transform = TransformationController();

    // Animation controller affects the width and height of the InteractiveViewer
    // We must adjust the translation vector so that when the
    // container expand or collapse, the position of the 'view box'
    // inside container changes accordingly so it doesn't create an
    // 'out of bound' effect.
    // Remove these listeners to see that for yourself
    double x, y, slideXPct = 0, slideYPct = 0;

    controller.addStatusListener((AnimationStatus status) {
      // save the attributes once at the moment of opening sheet or closing
      if (status == AnimationStatus.forward ||
          status == AnimationStatus.reverse) {
        x = transform.value.getTranslation().x;
        y = transform.value.getTranslation().y;
        slideXPct = x / (containerWidth - viewerWidth);
        slideYPct = y / (containerHeight - viewerHeight);
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
  }

  double lerp(double min, double max) =>
      lerpDouble(min, max, controller.value) ?? 0;

  /// Scrollable horizontally when collapsed, vertically when expanded
  Widget scrollableViewBox() {
    return SizedBox(
      width: viewerWidth,
      height: viewerHeight,
      child: InteractiveViewer(
        transformationController: transform,
        constrained: false,
        scaleEnabled: false,
        panAxis: sheetOpen ? PanAxis.vertical : PanAxis.horizontal,
        child: Stack(
          children: <Widget>[
            Container(
              width: containerWidth,
              height: containerHeight,
            ),
            for (SexyBottomSheetItem item in widget.items) tile(item),
            if (widget.imageBuilder != null)
              for (SexyBottomSheetItem item in widget.items) icon(item),
          ],
        ),
      ),
    );
  }

  Widget tile(SexyBottomSheetItem item) {
    int index = widget.items.indexOf(item);
    if (index == -1) return SizedBox();
    if (item.hideWhenCollapsed && !sheetOpen) return SizedBox();

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
          builder: (context, selectedIndex, child) {
            final selected = index == selectedIndex;

            return Container(
              margin: EdgeInsets.all(4.0),
              decoration: selected && !item.disallowSelection
                  ? BoxDecoration(
                      border: Border.all(
                        color: isThemeCurrentlyDark(context)
                            ? Theme.of(context).primaryColorLight
                            : Theme.of(context).primaryColorDark,
                      ),
                    )
                  : BoxDecoration(),
              child: IgnorePointer(
                ignoring: selected,
                child: child,
              ),
            );
          },
          child: item.onDismiss != null
              ? Dismissible(
                  key: item.key,
                  child: item.child,
                  background: Container(color: Theme.of(context).disabledColor),
                  behavior: HitTestBehavior.translucent,
                  confirmDismiss: (direction) {
                    return showAdaptiveDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Delete item?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                final result =
                                    await item.onDismiss?.call(context);
                                Navigator.pop(context, result);
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                )
              : item.child,
        ),
      ),
    );
  }

  void toggleBottomSheet() => controller.fling(velocity: sheetOpen ? -2 : 2);
}
