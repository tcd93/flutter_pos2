import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/login/login.dart';
import 'package:flutter_pos/pages/data/repos/cardItems/card_items.dart';
import 'package:flutter_pos/pages/data/repos/price.dart';
import 'package:flutter_pos/pages/main_section/page_view/collapsible_card/collapsible_card_delete_button.dart';
import 'package:flutter_pos/pages/main_section/page_view/collapsible_card/collapsible_card_rename_button.dart';
import 'package:flutter_pos/utils/text_styles.dart';
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

class _CardHeaderState extends ConsumerState<CollapsibleCardHeader>
    with SingleTickerProviderStateMixin {
  late Animation<Color?> color;
  late Animation<TextStyle> textStyle;
  final TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cred = ref.watch(loginProvider).value;
    final title = ref.watch(cardTitleProvider(widget.cardID)).value ?? '';
    final price = ref.watch(priceProvider(widget.cardID)).value ?? 0.0;

    return AnimatedBuilder(
      animation: widget.animation,
      builder: (context, popup) {
        return ListTile(
          title: Text(
            title,
            overflow: TextOverflow.fade,
            style: textStyle.value,
            maxLines: 1,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
          tileColor: price > 0 ? Theme.of(context).highlightColor : color.value,
          leading: Transform.rotate(
            angle: widget.animation.value * math.pi,
            child: const Icon(Icons.arrow_drop_up),
          ),
          trailing: popup,
        );
      },
      child: cred != null
          ? PopupMenuButton(
              position: PopupMenuPosition.under,
              offset: const Offset(36.0, 0.0),
              constraints: const BoxConstraints.tightFor(),
              surfaceTintColor: Theme.of(context).colorScheme.onBackground,
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    value: 'rename',
                    padding: const EdgeInsets.symmetric(horizontal: 1.0),
                    child: const RenameButton(),
                    onTap: () {
                      nameController.text = title;
                      RenameButton.showRenameSheet(
                        context,
                        cardID: widget.cardID,
                        titleController: nameController,
                      );
                    },
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    padding: const EdgeInsets.symmetric(horizontal: 1.0),
                    child: const DeleteButton(),
                    onTap: () {
                      DeleteButton.showDeleteDialog(
                        context,
                        pageID: widget.pageID,
                        title: title,
                        cardID: widget.cardID,
                      );
                    },
                  ),
                ];
              },
            )
          : null,
    );
  }

  @override
  void didChangeDependencies() {
    color = ColorTween(
      begin: Colors.transparent,
      end: Theme.of(context).highlightColor,
    ).animate(widget.animation);

    textStyle = TextStyleTween(
      begin: HeadingStylesMaterial.secondary,
      end: HeadingStylesMaterial.primary,
    ).animate(widget.animation);

    super.didChangeDependencies();
  }
}
