import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/repos/cardItems/card_items.dart';
import 'package:flutter_pos/pages/main_section/page_view/card_adder.dart';
import 'package:flutter_pos/pages/main_section/page_view/collapsible_card/collapsible_card.dart';
import 'package:flutter_pos/pages/main_section/page_view/menu_view/menu.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CollapsibleCardList extends ConsumerWidget {
  final int pageID;

  const CollapsibleCardList(this.pageID, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ids = ref.watch(cardIDProvider(pageID)).value ?? [];

    return SingleChildScrollView(
      child: Column(
        children: [
          ...ids.map((id) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: _Card(pageID, id),
            );
          }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CardAdder(pageID),
          ),
        ],
      ),
    );
  }
}

class _Card extends ConsumerWidget {
  final int pageID;
  final int cardID;

  const _Card(this.pageID, this.cardID);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final pallette = isThemeCurrentlyDark(context) ? darkPallete : lightPallete;

    return OpenContainer(
      tappable: false,
      closedElevation: 0.0,
      closedColor: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      closedShape: BeveledRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
      openElevation: 0.0,
      openColor: Colors.transparent,
      // openColor: pallette[widget.pageID % pallette.length]!,
      transitionDuration: const Duration(milliseconds: 500),
      closedBuilder: (context, action) {
        return CollapsibleCard(
          cardID: cardID,
          pageID: pageID,
          openContainer: action,
        );
      },
      openBuilder: (context, closeContainer) {
        return Menu(closeContainer: closeContainer);
      },
      // this routeSettings is for better URL display on web platform only,
      // onGenerateRoute is not called in main app
      routeSettings: RouteSettings(name: '/menu?cardId=${cardID.toString()}'),
    );
  }

  bool isInt(double? number) {
    if (number == null) return false;
    return number - number.truncate() == 0;
  }
}
