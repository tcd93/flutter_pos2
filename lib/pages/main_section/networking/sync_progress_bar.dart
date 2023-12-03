import 'package:flutter/material.dart';
import 'package:flutter_pos/p2p/syncer.dart';
import 'package:flutter_pos/pages/data/db.dart';
import 'package:flutter_pos/pages/data/webrtc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<String?> syncDialog(BuildContext context, WidgetRef ref) async {
  final db = ref.read(dbProvider);
  final service = ref.read(serviceProvider)!;
  final trans = await db.select(db.transactions).get();
  //  maxsize for webrtc datachannel is around 16kb
  await for (final sublist in Syncer.wrapTen(trans)) {
    service.send(sublist);
  }

  return showAdaptiveDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        content: Column(
          children: [
            Text('Transferring transactional data to other linked devices...'),
            // TODO
            // select top 10 from transactions
            // also select from transaction_details
            LinearProgressIndicator(),
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
