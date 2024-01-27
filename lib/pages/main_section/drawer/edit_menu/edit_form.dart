import 'package:flutter/material.dart';
import 'package:flutter_pos/utils/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditForm extends ConsumerWidget {
  final PageController pageControl;

  const EditForm(this.pageControl, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      canPop: false,
      child: const Placeholder(color: Colors.blue),
      onPopInvoked: (didPop) {
        pageControl.animateToPage(
          0,
          duration: const Duration(
            milliseconds: AppTheme.carouselDuration,
          ),
          curve: Curves.easeOut,
        );
      },
    );
  }
}
