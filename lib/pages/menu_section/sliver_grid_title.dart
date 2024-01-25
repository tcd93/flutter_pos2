import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/db.dart';
import 'package:flutter_pos/utils/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SliverGridTitle extends StatelessWidget {
  final int cardID;

  const SliverGridTitle(this.cardID, {super.key});

  @override
  Widget build(BuildContext context) {
    final toolBarHeight = AppTheme.cardHeightMax *
        (AppTheme.endHeightFactor - AppTheme.beginHeightFactor);

    return SliverAppBar(
      primary: false,
      floating: true,
      toolbarHeight: toolBarHeight,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      title: Consumer(
        builder: (context, ref, _) {
          final price = ref.watch(priceProvider(cardID)) ?? 0.0;
          final note = ref.watch(noteProvider(cardID)).value ?? '';
          return ListTile(
            title: price > 0 ? Text(price.toString() + ' \$') : Text(''),
            contentPadding: EdgeInsets.zero,
            subtitle: note.isNotEmpty
                ? Text(note, maxLines: 2, overflow: TextOverflow.ellipsis)
                : null,
          );
        },
      ),
    );
  }
}
