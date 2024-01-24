import 'dart:math' as math;

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/db.dart';
import 'package:flutter_pos/pages/main_section/card_adder.dart';
import 'package:flutter_pos/pages/menu_section/menu.dart';
import 'package:flutter_pos/utils/app_theme.dart';
import 'package:flutter_pos/widgets/flat_collapsible_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Cards extends ConsumerWidget {
  final int pageID;

  const Cards(this.pageID);

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

class _Card extends ConsumerStatefulWidget {
  final int pageID;
  final int cardID;

  _Card(this.pageID, this.cardID);

  @override
  createState() => _CardState();
}

class _CardState extends ConsumerState<_Card>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController controller;
  bool expanded = false;

  // keepAlive this state to not reset animation controller upon
  // switching page view
  @override
  bool get wantKeepAlive => false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
      closedBuilder: collapsibleCard,
      openBuilder: (context, closeContainer) {
        return Menu(closeContainer: closeContainer);
      },
      routeSettings: RouteSettings(name: '/menu'),
    );
  }

  Widget cardDeleteButton(String title) {
    return TextButton(
      onPressed: () {
        showAdaptiveDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text('Delete $title?'),
              content: Text('Make sure table is currently empty'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    final result = await ref
                        .read(cardIDProvider(widget.pageID).notifier)
                        .remove(widget.cardID);

                    if (result is String) {
                      await showAdaptiveDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Delete failed'),
                            content: Text(result),
                          );
                        },
                      );
                    }

                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
      child: const Text('Delete'),
      style: ButtonStyle(
        foregroundColor: MaterialStatePropertyAll(Colors.red),
      ),
    );
  }

  Widget cardDetails(VoidCallback openContainer, double price) {
    return Consumer(
      builder: (context, ref, _) {
        final note = ref.watch(noteProvider(widget.cardID)).value ?? '';
        return ListTile(
          title: Text(price.toString() + ' \$'),
          trailing: OutlinedButton.icon(
            onPressed: () {
              ref.read(selectedCardProvider.notifier).open(widget.cardID);
              // Navigator.of(context).pushNamed('/menu');
              openContainer();
            },
            icon: Icon(Icons.menu_open_outlined),
            label: Text('Menu'),
          ),
          subtitle: note.isNotEmpty
              ? Text(note, maxLines: 2, overflow: TextOverflow.ellipsis)
              : null,
          isThreeLine: false,
        );
      },
    );
  }

  Widget cardHeader(double animationValue) {
    final title = ref.watch(cardTitleProvider(widget.cardID)).value ?? '';

    return GestureDetector(
      onLongPress: () {
        showAdaptiveDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            final textController = TextEditingController(text: title);
            return AlertDialog(
              content: TextFormField(
                controller: textController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  constraints: BoxConstraints.tightFor(width: 600),
                  labelText: 'Card Name',
                ),
                maxLength: 20,
                minLines: 1,
                maxLines: 1,
                scrollPhysics: NeverScrollableScrollPhysics(),
              ),
              actions: [
                cardDeleteButton(title),
                VerticalDivider(),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    ref
                        .read(cardTitleProvider(widget.cardID).notifier)
                        .set(textController.text);
                    Navigator.pop(context, 'OK');
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
      child: ListTile(
        title: Text(title, textScaler: TextScaler.linear(1.2)),
        leading: Transform.rotate(
          angle: math.pi * animationValue,
          child: Icon(Icons.arrow_drop_up),
        ),
      ),
    );
  }

  Widget collapsibleCard(BuildContext context, VoidCallback openContainer) {
    final price = ref.watch(priceProvider(widget.cardID)) ?? 0.0;
    return FlatCollapsibleCard(
      controller: controller,
      header: cardHeader,
      details: (_) => cardDetails(openContainer, price),
      headerColor: (controller) {
        return controller.isAnimating || controller.isCompleted || price > 0
            ? Theme.of(context).highlightColor
            : Colors.transparent;
      },
      onToggle: (expanded) => this.expanded = expanded,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: AppTheme.cardExpandDuration),
    );

    ref.listenManual(pageStatusProvider, (previous, next) {
      if (previous?.selected == widget.pageID) {
        controller.reverse();
      }
      if (this.expanded && next.selected == widget.pageID) {
        controller.forward();
      }
    });

    super.initState();
  }

  bool isInt(double? number) {
    if (number == null) return false;
    return number - number.truncate() == 0;
  }
}
