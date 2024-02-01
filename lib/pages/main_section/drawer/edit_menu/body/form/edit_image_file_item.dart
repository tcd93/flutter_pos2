import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos/image_type.dart';
import 'package:flutter_pos/pages/data/ephemeral.dart';
import 'package:flutter_pos/pages/data/repos/dishes/dishes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

final _logger = Logger('Edit Image File');

class EditImageFileItem extends ConsumerStatefulWidget {
  const EditImageFileItem({super.key});

  @override
  ConsumerState<EditImageFileItem> createState() => _EditImageUrlItemState();
}

class _EditImageUrlItemState extends ConsumerState<EditImageFileItem> {
  final filePath = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.file_present),
      title: const Text('Image from file'),
      onTap: () async {
        final editID = ref.watch(edittingDishIDProvider);
        if (editID == null) {
          throw '[editID] must not be null, code miss somewhere';
        }
        final dish = ref.read(dishItemProvider(editID)).value;
        if (dish == null) return;
        if (dish.imageType == ImageType.file)
          filePath.text = dish.imagePath ?? '';

        await showFileTextField(context, editID);
      },
    );
  }

  @override
  void dispose() {
    filePath.dispose();
    super.dispose();
  }

  Future<dynamic> showFileTextField(BuildContext context, int editID) {
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
              onEditingComplete: () => pickFile(editID),
              controller: filePath,
              maxLines: null,
              decoration: const InputDecoration(
                labelText: 'File',
              ),
              keyboardType: TextInputType.url,
              scrollPhysics: const NeverScrollableScrollPhysics(),
            ),
            trailing: IconButton(
              onPressed: () => pickFile(editID),
              icon: const Icon(Icons.folder),
            ),
          ),
        );
      },
    );
  }

  pickFile(int editID) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result == null) return;

    if (!kIsWeb) {
      final path = result.files.single.path;
      if (path == null) {
        _logger.severe('Path is empty, something\'s wrong');
      }
      _logger.info('File: $path');
      ref.read(dishItemProvider(editID).notifier).setFile(path!);
    } else {
      // on web platform we can't access path of picked file so have to load as memory data
      final data = result.files.single.bytes;
      if (data == null) {
        _logger.severe('Data is empty, something\'s wrong');
      }
      _logger.info('[Web] storing image bytes');
      ref.read(dishItemProvider(editID).notifier).setBytes(data!);
    }

    // dismiss current bottom sheet
    if (context.mounted) Navigator.of(context).pop();
  }
}
