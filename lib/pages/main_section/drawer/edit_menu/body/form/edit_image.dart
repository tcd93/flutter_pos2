import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/main_section/drawer/edit_menu/body/form/edit_image_camera_item.dart';
import 'package:flutter_pos/pages/main_section/drawer/edit_menu/body/form/edit_image_file_item.dart';
import 'package:flutter_pos/pages/main_section/drawer/edit_menu/body/form/edit_image_gallery_item.dart';
import 'package:flutter_pos/pages/main_section/drawer/edit_menu/body/form/edit_image_url_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditImage extends ConsumerWidget {
  const EditImage({super.key});

  static Future<T?> showSheet<T>(BuildContext context) async {
    if (context.mounted)
      return showModalBottomSheet<T>(
        context: context,
        builder: (_) => const EditImage(),
      );
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      children: const [
        if (!kIsWeb) EditImageCameraItem(),
        EditImageGalleryItem(),
        EditImageFileItem(),
        EditImageUrlItem(),
      ],
    );
  }
}
