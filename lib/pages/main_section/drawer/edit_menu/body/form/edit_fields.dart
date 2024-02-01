import 'package:flutter/material.dart';
import 'package:flutter_pos/database/drift_database.dart';
import 'package:flutter_pos/pages/data/ephemeral.dart';
import 'package:flutter_pos/pages/data/repos/dishes/dishes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

final _logger = Logger('Edit Fields');

class EditFields extends ConsumerStatefulWidget {
  const EditFields({super.key});

  @override
  ConsumerState<EditFields> createState() => _EditFieldsState();
}

class _EditFieldsState extends ConsumerState<EditFields> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final priceController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dishID = ref.watch(edittingDishIDProvider)!;
    final dish = ref.watch(dishItemProvider(dishID)).value;
    _logger.info('Editting dish id: $dishID, dish: $dish');
    if (dish == null) return const SizedBox();

    // add post frame callback
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      nameController.text = dish.name;
      priceController.text = dish.price.toString();
    });

    return Form(
      key: formKey,
      child: ListView(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              label: Text('Name'),
            ),
            controller: nameController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Name is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            decoration: const InputDecoration(
              label: Text('Price'),
            ),
            controller: priceController,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Price is required';
              }
              if (double.tryParse(value) == null) {
                return 'Must be number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          ButtonBar(
            children: [
              // Delete
              FilledButton.icon(
                onPressed: () async {
                  final result = await showDeleteDialog(context, dish);

                  if (!context.mounted) {
                    _logger.warning(
                      'BuildContext is dismounted after an async operation, '
                      'unable to pop routes',
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
                      'BuildContext is dismounted after an async operation, '
                      'unable to pop routes',
                    );
                    return;
                  }

                  Navigator.pop(context);
                },
                icon: const Icon(Icons.delete),
                label: const Text('Delete'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red[300]),
                ),
              ),
              // save
              ElevatedButton.icon(
                onPressed: () async {
                  if (formKey.currentState?.validate() == true) {
                    formKey.currentState?.save();
                    await ref.watch(dishItemProvider(dishID).notifier).set(
                          nameController.text,
                          double.parse(priceController.text),
                        );

                    if (mounted) Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.save),
                label: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<dynamic> showDeleteDialog(BuildContext context, Dish dish) {
    return showAdaptiveDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Delete ${dish.name}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final result =
                    await ref.watch(dishIDProvider.notifier).remove(dish.id);
                if (mounted) Navigator.pop(context, result);
              },
              child: const Text('Delete'),
            )
          ],
        );
      },
    );
  }
}
