import 'dart:ui';

import 'package:flutter_pos/utils/text_styles.dart';
import 'package:flutter_pos/utils/ui_helpers.dart';
import 'package:flutter/material.dart';

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

  final List<Widget> items;

  /// Display a row of Images in collapsed state from [items]
  final Widget Function(int index)? imageBuilder;
  final ValueNotifier<int> selectedIndex;

  SexyBottomSheet({
    required this.items,
    required this.selectedIndex,
    this.imageBuilder,
  });

  @override
  _SexyBottomSheetState createState() => _SexyBottomSheetState();
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

  double get sheetSize => widget.items.length * iconSize;

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

  Widget icon(Widget item) {
    int index = widget.items.indexOf(item);
    if (index == -1) return SizedBox();

    return Positioned(
      height: iconSize,
      width: iconSize,
      top: iconTopMargin(index),
      left: iconLeftMargin(index),
      child: Container(
        margin: EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
          child: widget.imageBuilder?.call(index),
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
            for (Widget item in widget.items) tile(item),
            for (Widget item in widget.items) icon(item),
            for (Widget item in widget.items) selectionBox(item),
          ],
        ),
      ),
    );
  }

  // build the rectangle around the "selected" icon
  Widget selectionBox(Widget item) {
    int index = widget.items.indexOf(item);
    return Positioned(
      top: iconTopMargin(index),
      left: iconLeftMargin(index),
      width: lerp(iconSize, screenWidth),
      height: iconSize,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent, // must use translucent
        onTap: () => widget.selectedIndex.value = index,
        child: ValueListenableBuilder(
          valueListenable: widget.selectedIndex,
          builder: (context, selectedIndex, _) {
            final selected = index == selectedIndex;
            return Container(
              margin: EdgeInsets.all(8.0),
              decoration: selected
                  ? BoxDecoration(
                      border: Border.all(
                        width: 1.5,
                        color: isThemeCurrentlyDark(context)
                            ? Theme.of(context).primaryColorLight
                            : Theme.of(context).primaryColorDark,
                      ),
                    )
                  : BoxDecoration(),
            );
          },
        ),
      ),
    );
  }

  Widget tile(Widget item) {
    int index = widget.items.indexOf(item);
    if (index == -1) return SizedBox();

    return Positioned(
      top: iconTopMargin(index),
      left: iconLeftMargin(index),
      width: lerp(iconSize, screenWidth),
      height: iconSize,
      child: Opacity(
        opacity: controller.value,
        child: Card(
          // color: invertColorsMaterial(context),
          margin: EdgeInsets.all(15.0),
          child: Padding(
            padding: EdgeInsets.only(left: iconSize),
            child: Align(
              alignment: Alignment.centerLeft,
              child: DefaultTextStyle.merge(
                style: SubHeadingStylesMaterial.primary,
                child: widget.items[index],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void toggleBottomSheet() => controller.fling(velocity: sheetOpen ? -2 : 2);
}
