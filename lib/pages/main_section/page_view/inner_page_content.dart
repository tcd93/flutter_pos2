import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/db.dart';
import 'package:flutter_pos/pages/data/repos/pages/pages.dart';
import 'package:flutter_pos/pages/main_section/page_view/collapsible_card/collapsible_card_list.dart';
import 'package:flutter_pos/utils/app_theme.dart';
import 'package:flutter_pos/utils/text_styles.dart';
import 'package:flutter_pos/widgets/sexy_bottom_sheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

final _logger = Logger('Page Body');

class InnerPageContent extends ConsumerStatefulWidget {
  final ValueNotifier<int> sheetIndexNotifier;

  const InnerPageContent(this.sheetIndexNotifier, {super.key});

  @override
  createState() => _InnerPageContentState();
}

class _InnerPageContentState extends ConsumerState<InnerPageContent> {
  // final lqControl = LiquidController();
  final pageControl = PageController(viewportFraction: 0.82);
  bool animating = false;

  void animateToItem(int? index) async {
    if (index == null) return;
    // lqControl.animateToPage(page: index, duration: AppTheme.carouselDuration);
    animating = true;
    await pageControl.animateToPage(
      index,
      duration: const Duration(milliseconds: AppTheme.carouselDuration),
      curve: Curves.easeIn,
    );
    animating = false;
  }

  @override
  Widget build(BuildContext context) {
    final pageIDs = ref.watch(pageIDProvider).value;
    // final pallete = isThemeCurrentlyDark(context) ? darkPallete : lightPallete;

    if (pageIDs == null) return const CircularProgressIndicator();

    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        // background
        // LiquidSwipe.builder(
        //   initialPage: 0,
        //   fullTransitionValue: 350.0,
        //   enableLoop: false,
        //   waveType: WaveType.liquidReveal,
        //   liquidController: lqControl,
        //   itemBuilder: (context, index) {
        //     // pageIDs size might change after page modification
        //     // LiquidSwipe's array size may be temporarily out of sync
        //     if (index >= pageIDs.length) {
        //       return Container(
        //         color: pallete[index % pallete.length],
        //       );
        //     }
        //     return Container(
        //       color: pallete[index % pallete.length],
        //       key: ValueKey(pageIDs[index]),
        //     );
        //   },
        //   itemCount: pageIDs.length,
        // ),
        PageView(
          controller: pageControl,
          scrollBehavior: ScrollConfiguration.of(context).copyWith(
            dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
              PointerDeviceKind.trackpad,
            },
          ),
          onPageChanged: (onScreenIndex) {
            if (onScreenIndex >= pageIDs.length) return;

            final pageStatus = ref.read(pageStatusProvider.notifier);
            pageStatus.current(pageIDs[onScreenIndex]);
            final selectIdx =
                pageIDs.indexOf(ref.read(pageStatusProvider).selected);

            // in case of swiping to change page, sync the provider's index state
            if ((onScreenIndex - selectIdx).abs() == 1 && !animating) {
              widget.sheetIndexNotifier.value = onScreenIndex;

              pageStatus.select(pageIDs[onScreenIndex]);
            }
          },
          children: [
            ...pageIDs.map((pageID) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  vertical: SexyBottomSheet.minHeight,
                ),
                key: ValueKey(pageID),
                child: CollapsibleCardList(pageID),
              );
            })
          ],
        ),
        Positioned(
          right: 5,
          top: 5,
          child: IconButton(
            onPressed: () {
              Scaffold.maybeOf(context)?.openEndDrawer();
            },
            icon: const Icon(Icons.settings),
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
              _logger.info('Current selected page id: $pageID');
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
      final pageIDs = ref.read(pageIDProvider).value;
      if (pageIDs == null || widget.sheetIndexNotifier.value >= pageIDs.length)
        return;

      ref
          .read(pageStatusProvider.notifier)
          .select(pageIDs[widget.sheetIndexNotifier.value]);

      animateToItem(widget.sheetIndexNotifier.value);
    });

    super.initState();
  }
}
