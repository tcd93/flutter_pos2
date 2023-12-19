import 'package:flutter/material.dart';
import 'package:flutter_pos/p2p/syncer.dart';
import 'package:flutter_pos/pages/data/db.dart';
import 'package:flutter_pos/pages/data/webrtc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<String?> syncDialog(BuildContext context, WidgetRef ref) async {
  final db = ref.read(dbProvider);
  final service = ref.read(serviceProvider);
  // TODO: select top 10, loop
  final trans = await db.select(db.transactions).get();

  final channelsDoneState = List.generate(
    ref.watch(labelProvider).length,
    (index) {
      final label = ref.watch(labelProvider)[index];
      if (label == null) return false;
      return ref.watch(syncDoneNotifierProvider(label));
    },
  );
  await for (final sublist in Syncer.wrapTen(trans)) {
    service.send(sublist);
  }

  return showAdaptiveDialog(
    context: context,
    barrierDismissible: channelsDoneState.every((element) => element == true),
    builder: (context) {
      return AlertDialog(
        content: Column(
          children: [
            if (channelsDoneState.contains((element) => element == false))
              Text(
                'Transferring transactional data to other linked devices...',
              ),
            if (channelsDoneState.contains((element) => element == false))
              LinearProgressIndicator(),
            if (channelsDoneState.every((element) => element == true))
              Text('Done')
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
