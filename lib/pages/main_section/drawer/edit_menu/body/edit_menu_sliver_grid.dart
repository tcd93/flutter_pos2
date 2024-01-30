import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/repos/dishes/dishes.dart';
import 'package:flutter_pos/pages/main_section/drawer/edit_menu/body/edit_menu_dish_tile.dart';
import 'package:flutter_pos/utils/app_theme.dart';
import 'package:flutter_pos/utils/ui_helpers.dart';
import 'package:flutter_pos/widgets/sliver_grid_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

final _logger = Logger('Edit Menu Grid');

// page 0

class EditMenuSliverGrid extends ConsumerWidget {
  final PageController pageControl;
  final ValueNotifier<String> filterString;

  const EditMenuSliverGrid({
    required this.pageControl,
    required this.filterString,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(dishIDProvider);

    return asyncData.when(
      data: (dishIDs) {
        return SafeArea(
          child: CustomScrollView(
            physics: const _NoImplicitScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            scrollBehavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
                PointerDeviceKind.trackpad,
              },
            ),
            slivers: [
              _SliverMenuGrid(pageControl, filterString),
            ],
          ),
        );
      },
      error: (error, stackTrace) {
        _logger.severe('Error', error, stackTrace);
        return const Center(child: Text('An error occurred'));
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

/// A workaround to the issue of implicitly scrolling the CustomScrollView
/// When textbox inside pinned SliverAppBar is focused.
/// See Flutter issue #25507
class _NoImplicitScrollPhysics extends AlwaysScrollableScrollPhysics {
  const _NoImplicitScrollPhysics({super.parent});

  @override
  bool get allowImplicitScrolling => false;

  @override
  AlwaysScrollableScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _NoImplicitScrollPhysics(parent: buildParent(ancestor));
  }
}

class _SliverMenuGrid extends ConsumerWidget {
  final PageController pageControl;
  final ValueNotifier<String> filterString;

  const _SliverMenuGrid(this.pageControl, this.filterString);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.shortestSide;
    final extent = calculateExtent(screenWidth);
    final margin = calculateMargin(screenWidth);

    final result = ref.watch(dishIDProvider);
    return result.when(
      data: (dishIDs) {
        return SliverAnimatedGridWrapper(
          notifier: filterString,
          filterer: (dishID) {
            final dish = ref.watch(dishItemProvider(dishID)).value!;
            return dish.name.contains(filterString.value);
          },
          itemList: dishIDs,
          widgetBuilder: (dishID, animation) {
            return EditMenuDishTile(
              key: ValueKey(dishID),
              dishID: dishID,
              size: Size.square(extent),
              animation: animation,
              onTap: () {
                pageControl.nextPage(
                  duration: const Duration(
                    milliseconds: AppTheme.carouselDuration,
                  ),
                  curve: Curves.easeIn,
                );
              },
            );
          },
          delegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: extent,
            mainAxisExtent: extent,
            crossAxisSpacing: margin / 2,
            mainAxisSpacing: margin / 2,
          ),
          padding: EdgeInsets.symmetric(horizontal: margin),
        );
      },
      loading: () => const SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (e, s) => SliverToBoxAdapter(child: Text('Error: $e')),
    );
  }
}
