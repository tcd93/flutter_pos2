import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/db.dart';
import 'package:flutter_pos/utils/text_styles.dart';
import 'package:flutter_pos/widgets/sexy_bottom_sheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PageTile extends ConsumerWidget implements SexyBottomSheetItem {
  final int pageID;
  final BuildContext context;

  const PageTile(this.context, this.pageID);

  @override
  Widget get child => this;

  @override
  bool get disallowSelection => false;

  @override
  bool get hideWhenCollapsed => false;

  @override
  Widget? Function()? get imageBuilder {
    return () {
      return Image.asset(
        'assets/icon/icon-legacy.png',
        fit: BoxFit.cover,
      );
    };
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

      if (result is String) {
        await showAdaptiveDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            return AlertDialog(
              title: Text('Delete failed'),
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
      margin: EdgeInsets.all(15.0),
      key: ValueKey(pageID),
      child: Padding(
        padding: EdgeInsets.only(left: 100.0),
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
