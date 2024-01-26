import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pos/pages/data/db.dart';
import 'package:flutter_pos/pages/main_section/page_view/menu_view/body/sliver_menu_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'appbar/menu_search_bar.dart';
import 'body/sliver_grid_title.dart';

class Menu extends ConsumerStatefulWidget {
  /// Callback if placed inside an [OpenContainer]
  final void Function({Never returnValue})? closeContainer;

  const Menu({this.closeContainer, super.key});

  @override
  ConsumerState<Menu> createState() => _MenuState();
}

class _MenuState extends ConsumerState<Menu> {
  /// Since we're wrapping this inside an [OpenContainer], this page gets rebuild
  /// many times during the "opening" animation, use a timer to build the heavy
  /// gridview only after its complete to improve performance
  bool allowGridView = false;
  late final Timer gridAllowTimer;

  final scrollController = ScrollController();
  final filterString = ValueNotifier('');

  final enforceThreeLines =
      TextInputFormatter.withFunction((oldValue, newValue) {
    int newLines = newValue.text.split('\n').length;
    if (newLines > 3) {
      return oldValue;
    } else {
      return newValue;
    }
  });

  @override
  Widget build(BuildContext context) {
    final cardID = ref.read(selectedCardProvider);
    // final page = ref.watch(pageStatusProvider);
    if (cardID == null) {
      return const SizedBox();
    }
    // final pallette = isThemeCurrentlyDark(context) ? darkPallete : lightPallete;

    return Scaffold(
      // backgroundColor: pallette[page.selected % pallette.length]!,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigator.pop() also works but sometimes can throw errors
            // if placed inside OpenContainer
            if (widget.closeContainer != null) {
              ref.read(selectedCardProvider.notifier).close();
              widget.closeContainer?.call();
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: MenuSearchBar(filterString),
          ),
        ],
      ),
      body: SafeArea(
        child: DecoratedBox(
          decoration: const BoxDecoration(border: Border(top: BorderSide())),
          child: CustomScrollView(
            controller: scrollController,
            physics: const _NoImplicitScrollPhysics(parent: BouncingScrollPhysics()),
            scrollBehavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
                PointerDeviceKind.trackpad,
              },
            ),
            slivers: [
              SliverGridTitle(cardID),
              if (allowGridView) SliverMenuGrid(filterString),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: ButtonBar(
          children: [
            noteButton(cardID),
            checkOutButton(cardID),
          ],
        ),
      ),
    );
  }

  Widget checkOutButton(int cardID) {
    return Consumer(
      builder: (context, ref, _) {
        final control = ref.read(menuControlProvider(cardID));
        final price = ref.watch(priceProvider(cardID)) ?? 0.0;
        final note = ref.watch(noteProvider(cardID)).value;
        return ElevatedButton.icon(
          onPressed: price > 0
              ? () async {
                  await control.checkOut(price, note);
                  widget.closeContainer?.call();
                }
              : null,
          icon: const Icon(Icons.playlist_add_check),
          label: const Text('Checkout'),
        );
      },
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    gridAllowTimer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    gridAllowTimer = Timer(const Duration(milliseconds: 450), () {
      setState(() => allowGridView = true);
    });
    super.initState();
  }

  Widget noteButton(int cardID) {
    return IconButton(
      onPressed: () {
        showAdaptiveDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            final note = ref.read(noteProvider(cardID)).value ?? '';
            final textController = TextEditingController(text: note);
            return AlertDialog(
              content: TextFormField(
                controller: textController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  constraints: BoxConstraints.tightFor(width: 600),
                  labelText: 'Note',
                ),
                maxLength: 100,
                minLines: 3,
                maxLines: 3,
                inputFormatters: [enforceThreeLines],
                scrollPhysics: const NeverScrollableScrollPhysics(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    ref
                        .read(noteProvider(cardID).notifier)
                        .takeNote(textController.text);
                    Navigator.pop(context, 'OK');
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
      icon: const Icon(Icons.note_add),
      tooltip: 'Note',
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
