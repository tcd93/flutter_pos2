import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/repos/default_discount/default_discount.dart';
import 'package:flutter_pos/pages/main_section/common/extension/discount_rate_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

final _logger = Logger('Default Discount Rate');

class DefaultDiscountRate extends ConsumerWidget {
  const DefaultDiscountRate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final defaultDiscountRate = ref.watch(defaultDiscountProvider).value ?? 1.0;
    return ListTile(
      title: const Text('Change Default Discount %'),
      leading: const Icon(Icons.discount),
      onTap: () {
        showModalBottomSheet(
          enableDrag: false,
          context: context,
          builder: (context) {
            _logger.info(
              'defaultDiscountRate: ${defaultDiscountRate.toPercent().toString()}',
            );
            return Padding(
              // account for keyboard height
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: ListTile(
                title: Form(
                  key: formKey,
                  child: TextFormField(
                    autofocus: true,
                    initialValue: defaultDiscountRate.toPercent().toString(),
                    decoration: const InputDecoration(
                      labelText: 'Discount Rate',
                      suffix: Text('%'),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Rate is required';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Must be number';
                      }
                      if (double.parse(value) < 0 ||
                          double.parse(value) > 100) {
                        return 'Must be between 0 and 100';
                      }
                      return null;
                    },
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    scrollPhysics: const NeverScrollableScrollPhysics(),
                    onFieldSubmitted: (value) {
                      if (formKey.currentState?.validate() == true) {
                        ref.read(defaultDiscountProvider.notifier).set(
                              double.parse(value).toRate(),
                            );
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
