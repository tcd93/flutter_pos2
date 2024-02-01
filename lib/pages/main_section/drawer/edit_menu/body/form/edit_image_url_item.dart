import 'package:flutter/material.dart';
import 'package:flutter_pos/image_type.dart';
import 'package:flutter_pos/pages/data/ephemeral.dart';
import 'package:flutter_pos/pages/data/repos/dishes/dishes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditImageUrlItem extends ConsumerStatefulWidget {
  const EditImageUrlItem({super.key});

  @override
  ConsumerState<EditImageUrlItem> createState() => _EditImageUrlItemState();
}

class _EditImageUrlItemState extends ConsumerState<EditImageUrlItem> {
  final urlText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.add_link),
      title: const Text('Image from url'),
      onTap: () async {
        final editID = ref.watch(edittingDishIDProvider);
        if (editID == null) {
          throw '[editID] must not be null, code miss somewhere';
        }
        final dish = ref.read(dishItemProvider(editID)).value;
        if (dish == null) return;
        if (dish.imageType == ImageType.url) {
          urlText.text = dish.imagePath ?? '';
        }

        await showUrlTextField(context, editID);
      },
    );
  }

  @override
  void dispose() {
    urlText.dispose();
    super.dispose();
  }

  void setImageUrl(int dishID) {
    // dismiss current bottom sheet
    Navigator.of(context).pop();
    // change dish image type to url
    if (urlText.text.isNotEmpty)
      ref.read(dishItemProvider(dishID).notifier).setUrl(urlText.text);
  }

  Future<dynamic> showUrlTextField(BuildContext context, int editID) {
    return showModalBottomSheet(
      enableDrag: false,
      isScrollControlled: true, // set this to increase height of sheet
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
              onEditingComplete: () => setImageUrl(editID),
              controller: urlText,
              // minLines: 1,
              maxLines: null,
              decoration: const InputDecoration(
                labelText: 'Url',
              ),
              keyboardType: TextInputType.url,
              scrollPhysics: const NeverScrollableScrollPhysics(),
            ),
            // trailing: ListenableBuilder(
            //   listenable: urlText,
            //   builder: (context, _) {
            //     return IconButton(
            //       onPressed: () => setImageUrl(editID),
            //       icon: urlText.text.isNotEmpty
            //           ? const Icon(Icons.get_app)
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
