import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/ephemeral.dart';
import 'package:flutter_pos/pages/data/repos/dishes/dishes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

final _logger = Logger('Edit Image Gallery');

class EditImageGalleryItem extends ConsumerWidget {
  const EditImageGalleryItem({super.key});

  Future<Uint8List?> pickFileAsBytes() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.media,
    );
    if (result == null) return null;
    // on web platform we can't access path of picked file so have to load as memory data
    final data = result.files.single.bytes;
    if (data == null) {
      _logger.severe('Data is empty, something\'s wrong');
    }
    _logger.info('[Web] storing image bytes');
    return data;
  }

  Future<String?> pickFileAsPath() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.media,
    );
    if (result == null) return null;

    final path = result.files.single.path;
    if (path == null) {
      _logger.severe('Path is empty, something\'s wrong');
    }
    _logger.info('File: $path');
    return path;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.image),
      title: const Text('Image from gallery'),
      onTap: () async {
        final editID = ref.watch(edittingDishIDProvider);
        if (editID == null) {
          throw '[editID] must not be null, code miss somewhere';
        }
        final dish = ref.read(dishItemProvider(editID)).value;
        if (dish == null) return;

        if (kIsWeb) {
          final data = await pickFileAsBytes();
          if (data != null)
            ref.read(dishItemProvider(editID).notifier).setBytes(data);
        } else {
          final path = await pickFileAsPath();
          if (path != null)
            ref.read(dishItemProvider(editID).notifier).setFile(path);
        }

        // dismiss current bottom sheet
        if (context.mounted) Navigator.of(context).pop();
      },
    );
  }
}
