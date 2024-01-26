import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/db.dart';
import 'package:flutter_pos/pages/main_section/page_view/card_adder.dart';
import 'package:flutter_pos/pages/main_section/page_view/collapsible_card/collapsible_card.dart';
import 'package:flutter_pos/pages/main_section/page_view/menu_view/menu.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CollapsibleCardList extends ConsumerWidget {
  final int pageID;

  const CollapsibleCardList(this.pageID, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(cardIDProvider(pageID));
    return result.when(
      data: (ids) {
        return SingleChildScrollView(
          child: Column(
            children: [
              ...ids.map((id) {
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: _Card(pageID, id),
                );
              }),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: CardAdder(this.pageID),
              ),
            ],
          ),
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error: $e')),
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
      transitionDuration: Duration(milliseconds: 500),
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
      routeSettings: RouteSettings(name: '/menu'),
    );
  }

  bool isInt(double? number) {
    if (number == null) return false;
    return number - number.truncate() == 0;
  }
}
