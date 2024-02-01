import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/ephemeral.dart';
import 'package:flutter_pos/pages/main_section/common/extension/discount_rate_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DiscountButton extends ConsumerWidget {
  const DiscountButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final cardID = ref.watch(selectedCardProvider);
    if (cardID == null) throw 'cardID can\'t be null';
    final rate = ref.watch(discountRateProvider(cardID));

    return ElevatedButton(
      onPressed: () {
        showModalBottomSheet(
          enableDrag: false,
          context: context,
          builder: (context) {
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
                    minLines: 1,
                    maxLines: 1,
                    decoration: const InputDecoration(
                      labelText: 'Discount %',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    scrollPhysics: const NeverScrollableScrollPhysics(),
                    initialValue:
                        rate < 1.0 ? rate.toPercent().toStringAsFixed(1) : '',
                    // check if input is double
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return null;
                      }
                      if (double.tryParse(value) == null) {
                        return 'Enter valid discount';
                      }
                      if (double.parse(value) < 0) {
                        return 'Enter valid discount';
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) {
                      if (value.isEmpty) {
                        ref
                            .read(discountRateProvider(cardID).notifier)
                            .set(1.0);
                        Navigator.pop(context);
                      }
                      if (formKey.currentState?.validate() == true) {
                        formKey.currentState?.save();
                        ref.read(discountRateProvider(cardID).notifier).set(
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
      child: rate < 1.0
          ? Text('Discounted ${rate.toPercentStr()}')
          : const Text('Set Discount'),
    );
  }
}
