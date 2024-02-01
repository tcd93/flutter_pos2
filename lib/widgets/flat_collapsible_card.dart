import 'package:flutter/material.dart';

class FlatCollapsibleCard extends StatefulWidget {
  final Animation<double> animatableHeight;
  final Animation<double> animatableWidth;

  final Widget header;
  final Widget details;

  final void Function()? onToggle;

  const FlatCollapsibleCard({
    required this.header,
    required this.details,
    required this.animatableHeight,
    required this.animatableWidth,
    this.onToggle,
    super.key,
  });

  @override
  State<FlatCollapsibleCard> createState() => _FlatCollapsibleCardState();
}

class _FlatCollapsibleCardState extends State<FlatCollapsibleCard> {
  // keep it in state to prevent being affected by rebuilds
  late final double initialHeight = widget.animatableHeight.value;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animatableHeight,
      builder: (context, content) {
        return SizedBox(
          height: widget.animatableHeight.value,
          width: widget.animatableWidth.value,
          child: content,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: initialHeight,
            child: InkWell(
              onTap: widget.onToggle,
              child: widget.header,
            ),
          ),
          Expanded(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                border: Border(top: BorderSide()),
              ),
              child: widget.details,
            ),
          ),
        ],
      ),
    );
  }
}
