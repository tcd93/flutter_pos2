import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/ephemeral.dart';
import 'package:flutter_pos/pages/data/repos/dishes/dishes.dart';
import 'package:flutter_pos/pages/main_section/common/loading_bar.dart';
import 'package:flutter_pos/pages/main_section/drawer/edit_menu/body/grid/add_menu_tile.dart';
import 'package:flutter_pos/pages/main_section/drawer/edit_menu/body/grid/edit_menu_dish_tile.dart';
import 'package:flutter_pos/utils/ui_helpers.dart';
import 'package:flutter_pos/widgets/fill_last_child_grid_delegate.dart';
import 'package:flutter_pos/widgets/sliver_grid_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// page 0

class EditMenuSliverGrid extends ConsumerWidget {
  final ValueNotifier<String> filterString;

  const EditMenuSliverGrid({
    required this.filterString,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          _SliverMenuGrid(filterString),
          const SliverFillRemaining(
            hasScrollBody: false,
            child: AddMenuTile(),
          ),
        ],
      ),
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
  final ValueNotifier<String> filterString;

  const _SliverMenuGrid(this.filterString);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.shortestSide;
    final extent = calculateExtent(screenWidth);
    final margin = calculateMargin(screenWidth);

    final dishIDs = ref.watch(dishIDProvider).value;
    if (dishIDs == null) {
      return const SliverLoadingBar();
    }

    return SliverAnimatedGridWrapper(
      notifier: filterString,
      filterer: (dishID) {
        final dish = ref.read(dishItemProvider(dishID)).value;
        if (dish == null) return true;
        return dish.name
            .toLowerCase()
            .contains(filterString.value.toLowerCase());
      },
      itemList: dishIDs,
      widgetBuilder: (dishID, animation) {
        return EditMenuDishTile(
          key: ValueKey(dishID),
          dishID: dishID,
          size: Size.square(extent),
          animation: animation,
          onTap: () {
            ref.read(edittingDishIDProvider.notifier).set(dishID);
            Navigator.pushNamed(context, '/edit-menu?dishId=$dishID');
          },
        );
      },
      delegate: FillLastChildGridDelegate(
        dimension: extent,
        childCount: dishIDs.length,
      ),
      padding: EdgeInsets.symmetric(horizontal: margin),
    );
  }
}
