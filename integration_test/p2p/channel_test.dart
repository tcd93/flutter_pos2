import 'dart:async';

import 'package:drift/drift.dart' as d;
import 'package:flutter_pos/database/drift_database.dart';
import 'package:flutter_pos/database/drift_database_test.dart';
import 'package:flutter_pos/p2p/manager.dart';
import 'package:flutter_pos/p2p/syncer.dart';
import 'package:flutter_pos/pages/data/db.dart';
import 'package:flutter_pos/pages/data/webrtc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:integration_test/integration_test.dart';

//flutter drive --target=integration_test/p2p/channel.dart -d windows
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end (2 peers)', () {
    const String label = 'channel-1';
    late WebRtcManager signaler;
    late WebRtcManager receiver;
    Completer<RTCDataChannelState> channelStateCompleter = Completer();

    setUp(() async {
      signaler = WebRtcManager();
      receiver = WebRtcManager(onChannelState: (dc) {
        if (!channelStateCompleter.isCompleted)
          channelStateCompleter.complete(dc.state);
      });
    });

    tearDown(() async {
      await signaler.disconnect();
    });

    test('signal exchange successfully', () async {
      await signaler.startServer(passphrase: 'password123');
      await receiver.createChannel('localhost', label, 'password123');
      final connectionState = await channelStateCompleter.future;
      expect(
        connectionState,
        RTCDataChannelState.RTCDataChannelOpen,
        reason: 'data channel should be open after exchange',
      );
      expect(
        signaler.hosting,
        false,
        reason: 'hosting should be set to false after connection established',
      );
      expect(
        signaler.connections[0].label,
        'channel-1',
        reason: 'channel should be named "${label}"',
      );
      expect(
        receiver.connections[0].label,
        'channel-1',
        reason: 'channel should be named "${label}"',
      );
    });

    test('disconnect successfully from Signaler', () async {
      await signaler.disconnect();

      expect(signaler.connections, isEmpty);
      expect(receiver.connections, isEmpty);
    });

    test('disconnect successfully from Receiver', () async {
      await receiver.disconnect();

      expect(signaler.connections, isEmpty);
      expect(receiver.connections, isEmpty);
    });
  });

  group('end-to-end (3 peers)', () {
    const String label1 = 'channel-1';
    const String label2 = 'channel-2';
    late WebRtcManager signaler;
    late WebRtcManager receiver1;
    late WebRtcManager receiver2;
    Completer<RTCDataChannelState> channelStateCompleter1 = Completer();
    Completer<RTCDataChannelState> channelStateCompleter2 = Completer();

    setUp(() async {
      signaler = WebRtcManager();
      receiver1 = WebRtcManager(
        onChannelState: (dc) {
          if (!channelStateCompleter1.isCompleted)
            channelStateCompleter1.complete(dc.state);
        },
      );
      receiver2 = WebRtcManager(
        onChannelState: (dc) {
          if (!channelStateCompleter2.isCompleted)
            channelStateCompleter2.complete(dc.state);
        },
      );
    });

    tearDown(() async {
      await signaler.disconnect();
    });

    test('signal exchange successfully', () async {
      await signaler.startServer(passphrase: 'password123');
      await receiver1.createChannel('localhost', label1, 'password123');
      var connectionState = await channelStateCompleter1.future;
      expect(
        connectionState,
        RTCDataChannelState.RTCDataChannelOpen,
        reason: 'data channel should be open after exchange',
      );
      expect(
        signaler.hosting,
        false,
        reason: 'hosting should be set to false after connection established',
      );
      await signaler.startServer(passphrase: 'password123');
      await receiver2.createChannel('localhost', label2, 'password123');
      connectionState = await channelStateCompleter2.future;
      expect(
        connectionState,
        RTCDataChannelState.RTCDataChannelOpen,
        reason: 'data channel should be open after exchange',
      );

      expect(
        signaler.connections.map((c) => c.label).toList(),
        [label1, label2],
        reason:
            'should have two connections in Signaler() "${label1}" and "${label2}"',
      );
      expect(
        receiver1.connections[0].label,
        label1,
        reason: 'channel should be named "${label1}"',
      );
      expect(
        receiver2.connections[0].label,
        label2,
        reason: 'channel should be named "${label2}"',
      );
    });
  });

  group('cross device data sync (with provider test)', () {
    const String label = 'channel';
    const String label2 = 'channel-2';
    late ProviderContainer containerForSignaler;
    late ProviderContainer containerForReceiver;
    late ProviderContainer containerForReceiver2;
    late WebRtcManager signaler;
    late WebRtcManager receiver;
    late WebRtcManager receiver2;

    /// https://riverpod.dev/docs/essentials/testing
    Future<ProviderContainer> createContainer() async {
      final memdb = TestingDriftDB();
      await memdb.into(memdb.cardItems).insert(
          CardItemsCompanion.insert(id: d.Value(0), pageID: 0, title: 'test'));

      final container = ProviderContainer(
        overrides: [dbProvider.overrideWith((ref) => memdb)],
      );
      addTearDown(() async {
        await memdb.close();
        // container.dispose();
      });
      return container;
    }

    setUp(() async {
      d.driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
      containerForSignaler = await createContainer();
      containerForReceiver = await createContainer();
      containerForReceiver2 = await createContainer();

      signaler = containerForSignaler.read(serviceProvider);

      await signaler.startServer(passphrase: 'password123');
      receiver = containerForReceiver.read(serviceProvider);
      await receiver.createChannel('localhost', label, 'password123');

      final channelStateCompleter1 = Completer();
      final listener1 = containerForSignaler.listen(
        hostStatusProvider,
        (prev, after) {
          if (after == false) channelStateCompleter1.complete();
        },
      );
      await channelStateCompleter1.future;
      listener1.close();

      await signaler.startServer(passphrase: 'password123');
      receiver2 = containerForReceiver2.read(serviceProvider);
      await receiver2.createChannel('localhost', label2, 'password123');

      final channelStateCompleter2 = Completer();
      final listener2 = containerForSignaler.listen(
        hostStatusProvider,
        (prev, after) {
          if (after == false) channelStateCompleter2.complete();
        },
      );
      await channelStateCompleter2.future;
      listener2.close();
    });

    tearDown(() async {
      await receiver.disconnect();
      await receiver2.disconnect();
      await signaler.disconnect();
      containerForSignaler.dispose();
      containerForReceiver.dispose();
      containerForReceiver2.dispose();
    });

    test('send signal to insert new transaction in receiver', () async {
      final trx = Transaction(
          id: 100, cardID: 0, date: DateTime(2023, 30, 11), price: 100);

      await signaler.send(Syncer.wrap([trx]));

      final Completer<(bool?, bool)> resultCompleter = Completer();
      final listener = containerForReceiver.listen(
        syncDoneNotifierProvider(label),
        (prev, after) {
          if (!resultCompleter.isCompleted)
            resultCompleter.complete((prev, after));
        },
      );
      final (prev, after) = await resultCompleter.future;
      listener.close();
      expect(prev, false);
      expect(after, true);

      final doneNotiferOnSignalerAlsoFires = expectAsync2((prev, after) {
        expect(prev, false);
        expect(after, true);
      });
      containerForSignaler.listen(
        syncDoneNotifierProvider(label),
        doneNotiferOnSignalerAlsoFires,
      );

      final memdb = containerForReceiver.read(dbProvider);
      final query = memdb.select(memdb.transactions)
        ..where((r) => r.id.equals(100));
      final row = await query.getSingle();
      expect(row, trx);
    });

    test('broadcast new dozens of transactions to provider', () async {
      final trx = Transaction(
          id: 0, cardID: 0, date: DateTime(2023, 30, 11), time: 0, price: 100);

      // generate 25 mock transactions
      final trxs = List.generate(25, (index) {
        return trx.copyWith(
            id: index,
            time: d.Value(index),
            price: d.Value(100 + index.toDouble()));
      });

      // 3 batches: 10 - 10 - 5
      await for (final batch in Syncer.wrapTen(trxs)) {
        signaler.send(batch);
      }

      final memdb = containerForReceiver.read(dbProvider);
      final countQuery = (memdb.selectOnly(memdb.transactions)
            ..addColumns([d.countAll()]))
          .map((r) => r.read(d.countAll()));

      final Completer<(bool?, bool)> resultCompleter = Completer();
      final listener = containerForReceiver.listen(
        syncDoneNotifierProvider(containerForReceiver.read(labelProvider)[0]!),
        (prev, after) {
          if (!resultCompleter.isCompleted)
            resultCompleter.complete((prev, after));
        },
      );
      final (prev, after) = await resultCompleter.future;
      listener.close();
      expect(prev, false);
      expect(after, true);

      // expect syncDoneNotifier fire twice for each channel in Signaler
      final callback = expectAsync1((value) {
        expect(value, true);
      }, count: 2);
      final labels = containerForSignaler.read(labelProvider);
      labels.forEach((channel) {
        containerForSignaler.listen(
          syncDoneNotifierProvider(channel!),
          (previous, next) {
            callback(next);
          },
        );
      });

      final rowCount = await countQuery.getSingle();
      expect(rowCount, 25, reason: ' should have 25 rows in table');
    });
  });
}
