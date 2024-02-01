import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/login/login.dart';
import 'package:flutter_pos/pages/data/repos/cardItems/card_items.dart';
import 'package:flutter_pos/pages/data/repos/pages/pages.dart';
import 'package:flutter_pos/pages/main_section/bottom_bar/page_tile_delete_button.dart';
import 'package:flutter_pos/pages/main_section/bottom_bar/page_tile_rename_button.dart';
import 'package:flutter_pos/utils/text_styles.dart';
import 'package:flutter_pos/widgets/sexy_bottom_sheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PageTile extends ConsumerStatefulWidget implements SexyBottomSheetItem {
  final int pageID;
  final BuildContext context;

  const PageTile(this.context, this.pageID, {super.key});

  @override
  Widget? Function(double) get childBuilder {
    return (value) {
      if (value <= 0.3) {
        return Opacity(
          opacity: 1.0 - value,
          child: Center(
            child: DefaultTextStyle.merge(
              style: BodyStylesDefault.primary,
              child: Text(pageID.toString()),
            ),
          ),
        );
      }
      return this;
    };
  }

  @override
  bool get disallowSelection => false;

  @override
  Widget? Function(double)? get headerBuilder {
    return null;
    // return (value) {
    //   return Image.asset(
    //     'assets/icon/icon-legacy.png',
    //     fit: BoxFit.cover,
    //   );
    // };
  }

  @override
  Key get key => ValueKey(pageID);

  @override
  ConsumerState<PageTile> createState() => _PageTileState();
}

class _PageTileState extends ConsumerState<PageTile> {
  final pageTitleController = TextEditingController();

  @override
  void dispose() {
    pageTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pageID = widget.pageID;
    final name = ref.watch(pageNameProvider(pageID)).value;
    final cardIDs = ref.watch(cardIDProvider(pageID)).value;
    final cred = ref.watch(loginProvider).value;
    return Card(
      margin: const EdgeInsets.all(15.0),
      child: ListTile(
        // color: invertColorsMaterial(context),
        key: ValueKey(pageID),
        titleAlignment: ListTileTitleAlignment.bottom,
        // merge current text style with BodyStylesDefault.primary
        titleTextStyle: Theme.of(context).listTileTheme.titleTextStyle?.merge(
              BodyStylesDefault.primary,
            ),
        title: Text(name ?? ''),
        subtitle: Text('Cards: ${cardIDs?.length}'),
        trailing: cred != null
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
                        pageTitleController.text = name ?? '';
                        RenameButton.showRenameSheet(
                          context,
                          pageID: pageID,
                          titleController: pageTitleController,
                        );
                      },
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      padding: const EdgeInsets.symmetric(horizontal: 1.0),
                      child: const DeleteButton(),
                      onTap: () {
                        pageTitleController.text = name ?? '';
                        DeleteButton.showDeleteDialog(
                          context,
                          pageID: pageID,
                          title: name ?? '',
                        );
                      },
                    ),
                  ];
                },
              )
            : null,
      ),
    );
  }
}
