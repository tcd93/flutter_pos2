import 'package:flutter/material.dart';

class FlatCollapsibleCard extends StatelessWidget {
  final Animation<double> animatableHeight;
  final Animation<double> animatableWidth;

  final Widget header;
  final Widget details;

  final void Function()? onToggle;

  late final double initialHeight = animatableHeight.value;

  FlatCollapsibleCard({
    required this.header,
    required this.details,
    required this.animatableHeight,
    required this.animatableWidth,
    this.onToggle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animatableHeight,
      builder: (context, content) {
        return SizedBox(
          height: animatableHeight.value,
          width: animatableWidth.value,
          child: content,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: initialHeight,
            child: InkWell(
              child: header,
              onTap: onToggle,
            ),
          ),
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border(top: BorderSide()),
              ),
              child: details,
            ),
          ),
        ],
      ),
    );
  }
}
