import 'package:flutter/material.dart';

class LoadingBar extends StatelessWidget {
  const LoadingBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: FractionallySizedBox(
        widthFactor: 0.75,
        child: LinearProgressIndicator(),
      ),
    );
  }
}

class SliverLoadingBar extends StatelessWidget {
  const SliverLoadingBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverFillRemaining(
      child: Center(
        child: FractionallySizedBox(
          widthFactor: 0.75,
          child: LinearProgressIndicator(),
        ),
      ),
    );
  }
}
