import 'package:flutter/material.dart';

/// Mimics [PageView]'s transition, but with added benefit of able to set route
/// names of pages. Note that both pages must be wrapped with this builder to
/// work
Route leftSlidingPageBuilder(
  Widget page, {
  RouteSettings? settings,
  bool maintainState = true,
}) {
  return PageRouteBuilder(
    maintainState: maintainState,

    /// On entrance (didPush), [animation] will run from 0.0 to 1.0, [secondaryAnimation] won't run,
    /// On exit (didPop), [animation] will run from 1.0 to 0.0, [secondaryAnimation] won't run,
    /// If another route is pushed on top of current route, both will run from 0.0 to 1.0
    /// If another route is popped and this route becomes top, both will run from 1.0 to 0.0
    pageBuilder: (context, _, secondaryAnimation) {
      // secondaryAnimation.addListener(() {
      //   print('pageBuilder secondaryAnimation = ${secondaryAnimation.value}');
      // });
      final slideOutToLeft = Tween(
        begin: Offset.zero,
        end: const Offset(-1.0, 0.0),
      );
      return SlideTransition(
        position: slideOutToLeft.animate(
          CurvedAnimation(
            parent: secondaryAnimation,
            curve: Curves.linear,
          ),
        ),
        child: page,
      );
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // animation.addListener(() {
      //   print('transition builder animation = ${animation.value}');
      // });
      final slideInFromLeft = Tween(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      );
      return SlideTransition(
        position: slideInFromLeft.animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.linear,
          ),
        ),
        child: child,
      );
    },
    settings: settings,
  );
}
