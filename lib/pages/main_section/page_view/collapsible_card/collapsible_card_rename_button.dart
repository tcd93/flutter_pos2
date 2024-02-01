import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/repos/cardItems/card_items.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RenameButton extends ConsumerWidget {
  const RenameButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.edit),
        SizedBox(width: 4.0),
        Text('Rename'),
      ],
    );
  }

  static void _rename(BuildContext context, int cardID, String currentText) {
    // dismiss current bottom sheet
    Navigator.of(context).pop();
    // change dish image type to url
    if (currentText.isNotEmpty)
      ProviderScope.containerOf(context)
          .read(cardTitleProvider(cardID).notifier)
          .set(currentText);
  }

  static Future<dynamic> showRenameSheet(
    BuildContext context, {
    required int cardID,
    required TextEditingController titleController,
  }) async {
    return showModalBottomSheet(
      enableDrag: false,
      context: context,
      builder: (context) {
        return Padding(
          // account for keyboard height
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: ListTile(
            title: TextField(
              autofocus: true,
              controller: titleController,
              minLines: 1,
              maxLines: 1,
              maxLength: 20,
              decoration: InputDecoration(
                labelText: 'Table',
                counterText: '',
                suffix: ListenableBuilder(
                  listenable: titleController,
                  builder: (context, _) {
                    return Text(
                      '${titleController.value.text.length.toString()}/20',
                    );
                  },
                ),
              ),
              keyboardType: TextInputType.text,
              scrollPhysics: const NeverScrollableScrollPhysics(),
              onEditingComplete: () {
                _rename(context, cardID, titleController.text);
              },
            ),
            // trailing: ListenableBuilder(
            //   listenable: titleController,
            //   builder: (context, _) {
            //     return IconButton(
            //       onPressed: () {
            //         _rename(context, cardID, titleController.text);
            //       },
            //       icon: titleController.text.isNotEmpty
            //           ? const Icon(Icons.send)
            //           : const Icon(Icons.cancel),
            //     );
            //   },
            // ),
          ),
        );
      },
    );
  }
}
