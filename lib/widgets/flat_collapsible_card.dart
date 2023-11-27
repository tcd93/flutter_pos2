import 'package:flutter_pos/utils/app_theme.dart';
import 'package:flutter/material.dart';

class FlatCollapsibleCard extends StatefulWidget {
  final AnimationController controller;

  /// Different header color when animating?
  final Color Function(AnimationController controller)? headerColor;

  /// Builder for header section of card
  final Widget Function(double animationValue) header;

  /// Builder for collapsable section of card
  final Widget Function(double animationValue) details;
  final void Function(bool expanded)? onToggle;

  FlatCollapsibleCard({
    required this.controller,
    required this.header,
    required this.details,
    this.headerColor,
    this.onToggle,
    super.key,
  });

  @override
  State<FlatCollapsibleCard> createState() => _FlatCollapsibleCardState();
}

class _FlatCollapsibleCardState extends State<FlatCollapsibleCard>
    with SingleTickerProviderStateMixin {
  late Animation<double> animatableHeight;
  late Animation<double> animatableWidth;
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, details) {
        return SizedBox(
          height: animatableHeight.value * AppTheme.cardHeightMax,
          width: animatableWidth.value * screenWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: AppTheme.cardExpandDuration),
                height: AppTheme.beginHeightFactor * AppTheme.cardHeightMax,
                color: widget.headerColor?.call(widget.controller) ??
                    Colors.transparent,
                child: InkWell(
                  child: widget.header(widget.controller.value),
                  onTap: toggleCard,
                ),
              ),
              details!,
            ],
          ),
        );
      },
      child: Expanded(
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(top: BorderSide()),
          ),
          child: widget.details(widget.controller.value),
        ),
      ),
    );
  }

  @override
  void initState() {
    animatableHeight = Tween<double>(
      begin: AppTheme.beginHeightFactor,
      end: AppTheme.endHeightFactor,
    ).chain(CurveTween(curve: Curves.fastOutSlowIn)).animate(widget.controller);

    animatableWidth = Tween<double>(
      begin: AppTheme.beginWidthFactor,
      end: AppTheme.endWidthFactor,
    ).chain(CurveTween(curve: Curves.easeOutBack)).animate(widget.controller);

    super.initState();
  }

  toggleCard() {
    expanded ? widget.controller.reverse() : widget.controller.forward();
    expanded = !expanded;
    widget.onToggle?.call(expanded);
  }
}
