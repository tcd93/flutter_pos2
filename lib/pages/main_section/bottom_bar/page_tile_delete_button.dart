import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/repos/pages/pages.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

final _logger = Logger('Collapsible Card Delete');

class DeleteButton extends ConsumerWidget {
  const DeleteButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.remove_circle),
        SizedBox(width: 4.0),
        Text('Remove'),
      ],
    );
  }

  static Future<dynamic> showDeleteDialog(
    BuildContext context, {
    required int pageID,
    required String title,
  }) {
    return showAdaptiveDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete $title?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final result = await ProviderScope.containerOf(context)
                    .read(pageIDProvider.notifier)
                    .remove(pageID);

                if (!context.mounted) {
                  _logger.warning(
                    'BuildContext is dismounted after an async operation, unable to show '
                    'AdaptiveDialog',
                  );
                  return;
                }

                if (result is String) {
                  await showAdaptiveDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Delete failed'),
                        content: Text(result),
                      );
                    },
                  );
                }

                if (!context.mounted) {
                  _logger.warning(
                    'BuildContext is dismounted after an async '
                    'operation, unable to pop routes',
                  );
                  return;
                }

                Navigator.pop(context, result);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
