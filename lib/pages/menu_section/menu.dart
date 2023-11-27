import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pos/pages/data/db.dart';
import 'package:flutter_pos/pages/menu_section/dish_tile.dart';
import 'package:flutter_pos/utils/app_theme.dart';
import 'package:flutter_pos/utils/ui_helpers.dart';
import 'package:flutter_pos/widgets/anim_search_widget.dart';
import 'package:flutter_pos/widgets/sliver_grid_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final page = ref.watch(pageStatusProvider);
    if (cardID == null) {
      return SizedBox();
    }
    final pallette = isThemeCurrentlyDark(context) ? darkPallete : lightPallete;

    final title = ref.watch(cardTitleProvider(cardID)).value ?? '';

    return Scaffold(
      backgroundColor: pallette[page.selected]!,
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
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
            padding: EdgeInsets.only(right: 8.0),
            child: searchBar(),
          ),
        ],
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(border: Border(top: BorderSide())),
        child: CustomScrollView(
          controller: scrollController,
          physics: _NoImplicitScrollPhysics(parent: BouncingScrollPhysics()),
          scrollBehavior: ScrollConfiguration.of(context).copyWith(
            dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
              PointerDeviceKind.trackpad,
            },
          ),
          slivers: [
            sliverAppBar(cardID),
            sliverGrid(),
          ],
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
          icon: Icon(Icons.playlist_add_check),
          label: Text('Checkout'),
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
    gridAllowTimer = Timer(Duration(milliseconds: 450), () {
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
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  constraints: BoxConstraints.tightFor(width: 600),
                  labelText: 'Note',
                ),
                maxLength: 100,
                minLines: 3,
                maxLines: 3,
                inputFormatters: [enforceThreeLines],
                scrollPhysics: NeverScrollableScrollPhysics(),
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
      icon: Icon(Icons.note_add),
      tooltip: 'Note',
    );
  }

  Widget searchBar() {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: 200),
      child: AnimatedSearchBar(
        searchDecoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.zero,
          ),
          label: Text('Search', textScaler: TextScaler.linear(0.75)),
          labelStyle: TextStyle(fontWeight: FontWeight.w300),
          filled: true,
          fillColor: Theme.of(context).dialogBackgroundColor.withOpacity(0.4),
          isDense: true,
        ),
        searchIcon: Icon(
          Icons.search,
          key: ValueKey('open'),
          color: Theme.of(context).colorScheme.primary,
        ),
        closeIcon: Icon(
          Icons.close,
          key: ValueKey('close'),
          color: Theme.of(context).colorScheme.primary,
        ),
        onChanged: (filter) {
          filterString.value = filter;
        },
      ),
    );
  }

  Widget sliverAppBar(int cardID) {
    final toolBarHeight = AppTheme.cardHeightMax *
        (AppTheme.endHeightFactor - AppTheme.beginHeightFactor);

    return SliverAppBar(
      primary: false,
      floating: true,
      toolbarHeight: toolBarHeight,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      title: Consumer(
        builder: (context, ref, _) {
          final price = ref.watch(priceProvider(cardID)) ?? 0.0;
          final note = ref.watch(noteProvider(cardID)).value ?? '';
          return ListTile(
            title: price > 0 ? Text(price.toString() + ' \$') : Text(''),
            contentPadding: EdgeInsets.zero,
            subtitle: note.isNotEmpty
                ? Text(note, maxLines: 2, overflow: TextOverflow.ellipsis)
                : null,
          );
        },
      ),
    );
  }

  Widget sliverGrid() {
    if (!allowGridView) return SliverToBoxAdapter();
    final screenWidth = MediaQuery.of(context).size.shortestSide;

    double extent = switch (screenWidth) {
      < 600 /*phone*/ => screenWidth / 4,
      >= 600 && < 905 /*tablet*/ => screenWidth / 6,
      >= 905 && < 1240 => screenWidth / 8,
      >= 1240 && < 1440 => screenWidth / 10,
      _ => screenWidth / 12,
    };
    double margin = switch (screenWidth) {
      < 600 => 16,
      >= 600 && < 905 => 32,
      >= 905 && < 1240 =>
        lerpDouble(32, 200, (screenWidth - 905) / (1240 - 905))!,
      >= 1240 && < 1440 => 200,
      _ => 232,
    };

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
            final dish = ref.watch(dishItemProvider(dishID)).value!;
            return DecoratedBox(
              key: ValueKey(dish),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
              child: DishTile(
                dishID: dish.id,
                type: dish.imageType,
                imageData: dish.imageData,
                imagePath: dish.imagePath,
                size: Size.square(extent),
                animation: animation,
              ),
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
      loading: () => SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (e, s) => SliverToBoxAdapter(child: Text('Error: $e')),
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
