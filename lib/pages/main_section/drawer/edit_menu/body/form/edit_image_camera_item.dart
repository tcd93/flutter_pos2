import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/ephemeral.dart';
import 'package:flutter_pos/pages/data/repos/dishes/dishes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';

final _logger = Logger('Edit Image Camera');

class EditImageCameraItem extends ConsumerWidget {
  const EditImageCameraItem({super.key});

  Future<String?> takePicture() async {
    final ImagePicker picker = ImagePicker();
    final photo = await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      final path = photo.path;
      _logger.info('Successfully taken photo: $path');
      return path;
    }

    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.camera),
      title: const Text('Take photo'),
      onTap: () async {
        final editID = ref.watch(edittingDishIDProvider);
        if (editID == null) {
          throw '[editID] must not be null, code miss somewhere';
        }
        final dish = ref.read(dishItemProvider(editID)).value;
        if (dish == null) return;

        final path = await takePicture();
        if (path != null) {
          ref.read(dishItemProvider(editID).notifier).setFile(path);
        }

        // dismiss current bottom sheet
        if (context.mounted) Navigator.of(context).pop();
      },
    );
  }
}
