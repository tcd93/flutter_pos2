import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/login.dart';
import 'package:flutter_pos/pages/data/repos/pages/pages.dart';
import 'package:flutter_pos/utils/text_styles.dart';
import 'package:flutter_pos/widgets/sexy_bottom_sheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

final _logger = Logger('Page Tile');

class PageTile extends ConsumerWidget implements SexyBottomSheetItem {
  final int pageID;
  final BuildContext context;

  const PageTile(this.context, this.pageID, {super.key});

  @override
  Widget? Function(double) get childBuilder {
    return (value) {
      return Builder(
        builder: (context) {
          if (value <= 0.3) {
            return Opacity(
              opacity: 1.0 - value,
              child: Center(
                child: DefaultTextStyle.merge(
                  style: BodyStylesDefault.primary,
                  child: Text(pageID.toString()),
                ),
              ),
            );
          }
          return this;
        },
      );
    };
  }

  @override
  bool get disallowSelection => false;

  @override
  Widget? Function(double)? get headerBuilder {
    return null;
    // return (value) {
    //   return Image.asset(
    //     'assets/icon/icon-legacy.png',
    //     fit: BoxFit.cover,
    //   );
    // };
  }

  @override
  Key get key => ValueKey(pageID);

  @override
  Future<bool> Function(BuildContext)? get onDismiss {
    final loggedIn = ProviderScope.containerOf(context).read(loginProvider);
    if (!loggedIn) return null;

    return (context) async {
      final result = await ProviderScope.containerOf(context)
          .read(pageIDProvider.notifier)
          .remove(pageID);

      if (!context.mounted) {
        _logger.warning(
          'BuildContext is dismounted after an async operation, unable to show '
          'AdaptiveDialog',
        );
        return false;
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

        return false;
      }
      return true;
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(pageNameProvider(pageID)).value;
    return Card(
      // color: invertColorsMaterial(context),
      margin: const EdgeInsets.all(15.0),
      key: ValueKey(pageID),
      child: Padding(
        padding: const EdgeInsets.only(left: 100.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: DefaultTextStyle.merge(
            style: SubHeadingStylesMaterial.primary,
            child: Text(name ?? ''),
          ),
        ),
      ),
    );
  }
}
