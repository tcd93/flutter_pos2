import 'package:flutter/material.dart';

class FlatCollapsibleCard extends StatefulWidget {
  final Animation<double> controller;
  final double beginHeightFactor;
  final double beginWidthFactor;
  final double? endHeightFactor;
  final double? endWidthFactor;
  final double maxHeight;

  /// Builder for header section of card
  final Widget header;

  /// Builder for collapsable section of card
  final Widget details;
  final void Function(bool expanded)? onToggle;

  const FlatCollapsibleCard({
    required this.controller,
    required this.header,
    required this.details,
    required this.beginHeightFactor,
    required this.beginWidthFactor,
    required this.maxHeight,
    this.endHeightFactor,
    this.endWidthFactor,
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
          height: animatableHeight.value * widget.maxHeight,
          width: animatableWidth.value * screenWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: widget.beginHeightFactor * widget.maxHeight,
                child: InkWell(
                  child: widget.header,
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
          child: widget.details,
        ),
      ),
    );
  }

  @override
  void initState() {
    animatableHeight = Tween<double>(
      begin: widget.beginHeightFactor,
      end: widget.endHeightFactor,
    ).chain(CurveTween(curve: Curves.fastOutSlowIn)).animate(widget.controller);

    animatableWidth = Tween<double>(
      begin: widget.beginWidthFactor,
      end: widget.endWidthFactor,
    ).chain(CurveTween(curve: Curves.easeOutBack)).animate(widget.controller);

    super.initState();
  }

  toggleCard() {
    widget.onToggle?.call(expanded);
    expanded = !expanded;
  }
}
