import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/db.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CollapsibleCardHeader extends ConsumerStatefulWidget {
  final int cardID;
  final int pageID;
  final Animation<double> animation;

  const CollapsibleCardHeader({
    super.key,
    required this.cardID,
    required this.pageID,
    required this.animation,
  });

  @override
  ConsumerState<CollapsibleCardHeader> createState() => _CardHeaderState();
}

class _CardDeleteButton extends ConsumerWidget {
  final int pageID;
  final int cardID;
  final String title;

  const _CardDeleteButton({
    required this.pageID,
    required this.cardID,
    required this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                        .read(cardIDProvider(pageID).notifier)
                        .remove(cardID);

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
}

class _CardHeaderState extends ConsumerState<CollapsibleCardHeader>
    with SingleTickerProviderStateMixin {
  late Animation<Color?> color;

  @override
  Widget build(BuildContext context) {
    final title = ref.watch(cardTitleProvider(widget.cardID)).value ?? '';
    final price = ref.watch(priceProvider(widget.cardID)) ?? 0.0;

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
                _CardDeleteButton(
                  pageID: widget.pageID,
                  cardID: widget.cardID,
                  title: title,
                ),
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
      child: AnimatedBuilder(
        animation: widget.animation,
        builder: (context, icon) {
          return ListTile(
            title: Text(title, textScaler: TextScaler.linear(1.2)),
            tileColor:
                price > 0 ? Theme.of(context).highlightColor : color.value,
            leading: Transform.rotate(
              angle: widget.animation.value * math.pi,
              child: icon,
            ),
          );
        },
        child: Icon(Icons.arrow_drop_up),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    color = ColorTween(
      begin: Colors.transparent,
      end: Theme.of(context).highlightColor,
    ).animate(widget.animation);

    super.didChangeDependencies();
  }
}
