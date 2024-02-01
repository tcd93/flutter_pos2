import 'package:flutter/material.dart';

class LoadingBar extends StatelessWidget {
  final double widthFactor;
  const LoadingBar({this.widthFactor = 0.75, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        child: const LinearProgressIndicator(),
      ),
    );
  }
}

class SliverLoadingBar extends StatelessWidget {
  final double widthFactor;
  const SliverLoadingBar({this.widthFactor = 0.75, super.key});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Center(
        child: FractionallySizedBox(
          widthFactor: widthFactor,
          child: const LinearProgressIndicator(),
        ),
      ),
    );
  }
}
