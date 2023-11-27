import 'package:flutter_pos/pages/data/db.dart';
import 'package:flutter_pos/utils/app_theme.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CardAdder extends ConsumerWidget {
  final int pageID;

  const CardAdder(this.pageID, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loggedIn = ref.watch(loginProvider);
    if (!loggedIn) {
      return const SizedBox();
    }

    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: AppTheme.beginWidthFactor * screenWidth,
      height: AppTheme.beginHeightFactor * AppTheme.cardHeightMax,
      child: DottedBorder(
        dashPattern: [8, 4],
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            child: Center(
              child:
                  Text('Long Press To +', textScaler: TextScaler.linear(1.2)),
            ),
            onLongPress: () {
              ref.read(cardIDProvider(pageID).notifier).addCard('New Card');
            },
          ),
        ),
      ),
    );
  }
}
