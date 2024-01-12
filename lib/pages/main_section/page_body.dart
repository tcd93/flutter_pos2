import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/db.dart';
import 'package:flutter_pos/pages/main_section/card.dart';
import 'package:flutter_pos/utils/app_theme.dart';
import 'package:flutter_pos/utils/text_styles.dart';
import 'package:flutter_pos/utils/ui_helpers.dart';
import 'package:flutter_pos/widgets/sexy_bottom_sheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

class PageBody extends ConsumerStatefulWidget {
  final List<int> pageIDs;
  final ValueNotifier<int> sheetIndexNotifier;

  PageBody(
    this.pageIDs,
    this.sheetIndexNotifier,
  );

  @override
  createState() => _PageBodyState();
}

class _PageBodyState extends ConsumerState<PageBody> {
  final lqControl = LiquidController();
  final pageControl = PageController(viewportFraction: 0.9);
  bool animating = false;

  void animateToItem(int? index) async {
    if (index == null) return;
    lqControl.animateToPage(page: index, duration: AppTheme.carouselDuration);
    animating = true;
    await pageControl.animateToPage(
      index,
      duration: Duration(milliseconds: AppTheme.carouselDuration),
      curve: Curves.easeIn,
    );
    animating = false;
  }

  @override
  Widget build(BuildContext context) {
    final pallete = isThemeCurrentlyDark(context) ? darkPallete : lightPallete;
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        LiquidSwipe.builder(
          initialPage: 0,
          fullTransitionValue: 350.0,
          enableLoop: false,
          waveType: WaveType.liquidReveal,
          liquidController: lqControl,
          itemBuilder: (context, index) => Container(
            color: pallete[index % pallete.length],
          ), // background (needed to 'hide' next page of liquid swipe)
          itemCount: widget.pageIDs.length,
        ),
        PageView(
          children: [
            ...widget.pageIDs.map((pageID) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  vertical: SexyBottomSheet.minHeight,
                ),
                key: ValueKey(pageID),
                child: Cards(pageID),
              );
            })
          ],
          controller: pageControl,
          scrollBehavior: ScrollConfiguration.of(context).copyWith(
            dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
              PointerDeviceKind.trackpad,
            },
          ),
          onPageChanged: (onScreenIndex) {
            final pageStatus = ref.read(pageStatusProvider.notifier);
            pageStatus.current(onScreenIndex);

            // in case of swiping to change page, sync the provider's index state
            if ((onScreenIndex - ref.read(pageStatusProvider).selected).abs() ==
                    1 &&
                !animating) {
              widget.sheetIndexNotifier.value = onScreenIndex;

              pageStatus.select(onScreenIndex);
            }
          },
        ),
        Positioned(
          right: 5,
          top: 5,
          child: IconButton(
            onPressed: () {
              Scaffold.maybeOf(context)?.openEndDrawer();
            },
            icon: Icon(Icons.settings),
          ),
        ),
        Positioned(
          bottom: 40.0 + SexyBottomSheet.minHeight,
          right: 60.0,
          child: Consumer(
            builder: (context, ref, _) {
              final pageID = ref.watch(
                pageStatusProvider.select((p) => p.current),
              );
              final name = ref.watch(pageNameProvider(pageID)).value;

              return Text(name ?? '', style: HeadingStylesMaterial.primary);
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    pageControl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    widget.sheetIndexNotifier.addListener(() {
      ref.read(pageStatusProvider.notifier)
        ..select(widget.sheetIndexNotifier.value);

      animateToItem(widget.sheetIndexNotifier.value);
    });

    super.initState();
  }
}
