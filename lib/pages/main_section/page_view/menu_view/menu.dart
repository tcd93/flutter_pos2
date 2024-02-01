import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/ephemeral.dart';
import 'package:flutter_pos/pages/data/repos/line_item.dart';
import 'package:flutter_pos/pages/data/repos/price.dart';
import 'package:flutter_pos/pages/data/repos/transactions/transactions.dart';
import 'package:flutter_pos/pages/main_section/common/search_bar.dart';
import 'package:flutter_pos/pages/main_section/page_view/menu_view/body/bottom_sheet.dart';
import 'package:flutter_pos/pages/main_section/page_view/menu_view/body/sliver_grid_title.dart';
import 'package:flutter_pos/pages/main_section/page_view/menu_view/body/sliver_menu_grid.dart';
import 'package:flutter_pos/printer/blue_thermal_printer.dart';
import 'package:flutter_pos/utils/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

final _logger = Logger('Menu');

class Menu extends ConsumerStatefulWidget {
  /// Callback if placed inside an [OpenContainer]
  final void Function({Never returnValue})? closeContainer;

  const Menu({this.closeContainer, super.key});

  @override
  ConsumerState<Menu> createState() => _MenuState();
}

class _MenuState extends ConsumerState<Menu> {
  /// Since we're wrapping this inside an [OpenContainer], this page gets rebuild
  /// many times during the "opening" animation, use a timer to build the heavy
  /// gridview only after its complete to improve performance
  bool allowGridView = false;
  late final Timer gridAllowTimer;

  final scrollController = ScrollController();
  final filterString = ValueNotifier('');
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final cardID = ref.watch(selectedCardProvider);
    if (cardID == null) {
      return const SizedBox();
    }
    final discountedPrice = ref.watch(priceProvider(cardID)).value ?? 0.0;
    // final pallette = isThemeCurrentlyDark(context) ? darkPallete : lightPallete;

    return Scaffold(
      // backgroundColor: pallette[page.selected % pallette.length]!,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigator.pop() also works but sometimes can throw errors
            // if placed inside OpenContainer
            if (widget.closeContainer != null) {
              ref.read(selectedCardProvider.notifier).close();
              widget.closeContainer?.call();
            } else {
              Navigator.of(context).popUntil(ModalRoute.withName('/'));
            }
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: MySearchBar(filterString),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          // decoration: const BoxDecoration(border: Border(top: BorderSide())),
          padding: discountedPrice > 0
              ? const EdgeInsets.only(bottom: AppTheme.navBarHeight)
              : EdgeInsets.zero,
          child: CustomScrollView(
            controller: scrollController,
            physics: const _NoImplicitScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            scrollBehavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
                PointerDeviceKind.trackpad,
              },
            ),
            slivers: [
              SliverGridTitle(cardID),
              if (allowGridView) SliverMenuGrid(filterString),
            ],
          ),
        ),
      ),
      bottomSheet: AnimatedContainer(
        duration: Durations.medium3,
        curve: Curves.linear,
        height: discountedPrice > 0 ? AppTheme.navBarHeight : 0.0,
        child: bottomSheet(cardID),
      ),
    );
  }

  Widget bottomSheet(int cardID) {
    return MenuBottomSheet(
      checkOutButton: Consumer(
        builder: (context, ref, child) {
          final discountRate = ref.read(discountRateProvider(cardID));
          final originalPrice =
              ref.watch(originalPriceProvider(cardID)).value ?? 0.0;
          final discountedPrice = ref.watch(priceProvider(cardID)).value ?? 0.0;
          final lineItems = ref.watch(lineItemsProvider(cardID)).value ?? [];
          return OutlinedButton.icon(
            onPressed: discountedPrice > 0
                ? () => checkOut(cardID, lineItems, discountRate, originalPrice,
                    discountedPrice)
                : null,
            icon: const Icon(Icons.playlist_add_check),
            label: const Text('Checkout'),
          );
        },
      ),
    );
  }

  Future<void> checkOut(
    int cardID,
    List<LineItem> lineItems,
    double discountRate,
    double originalPrice,
    double currentPrice,
  ) async {
    if (lineItems.isEmpty) return;
    _logger.info('Checking out ${lineItems.length} items');

    final customerPaymentAmount = await confirmationBox(currentPrice);
    if (customerPaymentAmount == null) return;

    await ref.read(transactionProvider(cardID)).checkOut(cardID);
    widget.closeContainer?.call();

    Printer.print(
      checkoutTime: DateTime.now(),
      lineItems: lineItems,
      customerPayAmount: customerPaymentAmount,
      discountRate: discountRate,
      originalPrice: originalPrice,
    );
  }

  Future<double?> confirmationBox(double currentPrice) async {
    return showModalBottomSheet(
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
              key: _formKey,
              child: TextFormField(
                autofocus: true,
                initialValue: currentPrice.roundToDouble().toString(),
                decoration: const InputDecoration(
                  labelText: 'Customer Payment',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Required';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Must be number';
                  }
                  return null;
                },
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                scrollPhysics: const NeverScrollableScrollPhysics(),
                onFieldSubmitted: (payment) {
                  if (_formKey.currentState?.validate() == true) {
                    Navigator.pop(context, double.parse(payment));
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    gridAllowTimer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    gridAllowTimer = Timer(const Duration(milliseconds: 450), () {
      setState(() => allowGridView = true);
    });
    super.initState();
  }
}

/// A workaround to the issue of implicitly scrolling the CustomScrollView
/// When textbox inside pinned SliverAppBar is focused.
/// See Flutter issue #25507
class _NoImplicitScrollPhysics extends AlwaysScrollableScrollPhysics {
  const _NoImplicitScrollPhysics({super.parent});

  @override
  bool get allowImplicitScrolling => false;

  @override
  AlwaysScrollableScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _NoImplicitScrollPhysics(parent: buildParent(ancestor));
  }
}
