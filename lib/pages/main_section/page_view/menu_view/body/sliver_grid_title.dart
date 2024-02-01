import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/ephemeral.dart';
import 'package:flutter_pos/pages/data/repos/cardItems/card_items.dart';
import 'package:flutter_pos/pages/data/repos/price.dart';
import 'package:flutter_pos/pages/data/repos/servings_note/servings_note.dart';
import 'package:flutter_pos/pages/main_section/common/extension/price_ext.dart';
import 'package:flutter_pos/pages/main_section/page_view/menu_view/body/discount_button.dart';
import 'package:flutter_pos/utils/app_theme.dart';
import 'package:flutter_pos/utils/text_styles.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SliverGridTitle extends ConsumerWidget {
  final int cardID;

  const SliverGridTitle(this.cardID, {super.key});

  Widget title(BuildContext context, WidgetRef ref) {
    final cardTitle = ref.watch(cardTitleProvider(cardID)).value ?? '';
    final discountRate = ref.watch(discountRateProvider(cardID));
    final origPrice = ref.watch(originalPriceProvider(cardID)).value ?? 0.0;
    final price = ref.watch(priceProvider(cardID)).value ?? 0.0;

    if (price == 0.0) {
      return Text(cardTitle, style: HeadingStylesMaterial.primary);
    }
    if (discountRate == 1.0) {
      return Text(
        '$cardTitle (${price.toDisplay()})',
        style: HeadingStylesMaterial.primary,
      );
    }
    if (discountRate < 1.0) {
      // return text widget with striked-over style original price and green text discounted price
      return RichText(
        text: TextSpan(
          style: HeadingStylesMaterial.primary,
          children: [
            TextSpan(text: '$cardTitle ('),
            TextSpan(
              text: origPrice.toDisplay(),
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                fontSize: 13.0,
                color: Theme.of(context).disabledColor,
              ),
            ),
            const TextSpan(text: ' '),
            TextSpan(
              text: price.toDisplay(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const TextSpan(text: ')'),
          ],
        ),
      );
    }
    throw 'Invalid discount rate';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const toolBarHeight = AppTheme.cardHeightMax *
        (AppTheme.endHeightFactor - AppTheme.beginHeightFactor);
    final note = ref.watch(noteProvider(cardID)).value ?? '';

    return SliverAppBar(
      primary: false,
      floating: true,
      toolbarHeight: toolBarHeight,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      title: ListTile(
        title: title(context, ref),
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
        subtitle: note.isNotEmpty
            ? Text(note, maxLines: 2, overflow: TextOverflow.ellipsis)
            : null,
      ),
      actions: const [
        SizedBox(width: 16.0),
        DiscountButton(),
        SizedBox(width: 16.0),
      ],
    );
  }
}
