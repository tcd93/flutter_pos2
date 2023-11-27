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
    late TestingDriftDB memdb;
    late ProviderContainer containerForSignaler;
    late ProviderContainer containerForReceiver;
    late WebRtcManager signaler;
    late WebRtcManager receiver;

    /// https://riverpod.dev/docs/essentials/testing
    ProviderContainer createContainer({
      ProviderContainer? parent,
      List<Override> overrides = const [],
      List<ProviderObserver>? observers,
    }) {
      final container = ProviderContainer(
        parent: parent,
        overrides: overrides,
        observers: observers,
      );
      addTearDown(container.dispose);
      return container;
    }

    setUp(() async {
      memdb = TestingDriftDB();
      await memdb.into(memdb.cardItems).insert(
          CardItemsCompanion.insert(id: d.Value(0), pageID: 0, title: 'test'));

      containerForSignaler = createContainer(
        overrides: [dbProvider.overrideWith((ref) => memdb)],
      );

      containerForReceiver = createContainer(
        overrides: [dbProvider.overrideWith((ref) => memdb)],
      );

      signaler = containerForSignaler.read(serviceProvider);
      await signaler.startServer(passphrase: 'password123');
      receiver = containerForReceiver.read(serviceProvider);
      await receiver.createChannel('localhost', label, 'password123');

      final Completer channelStateCompleter = Completer();
      final listener = containerForReceiver.listen(
        peerConnectionStateProvider,
        (prev, after) {
          if (after == RTCPeerConnectionState.RTCPeerConnectionStateConnected) {
            channelStateCompleter.complete();
          }
        },
      );
      await channelStateCompleter.future;
      listener.close();
    });

    tearDown(() async {
      receiver.disconnect();
      signaler.disconnect();
      await memdb.close();
    });

    test('send signal to insert new transaction in receiver', () async {
      final trx = Transaction(
          id: 100, cardID: 0, date: DateTime(2023, 30, 11), price: 100);

      await signaler.send(Syncer.wrap([trx]));

      final Completer<(int? prev, int? after)> resultCompleter = Completer();
      final listener = containerForReceiver.listen(
        resultNotifierProvider(1),
        (prev, after) {
          if (!resultCompleter.isCompleted)
            resultCompleter.complete((prev, after));
        },
      );
      final (prev, after) = await resultCompleter.future;
      listener.close();
      expect(prev, 0);
      expect(after, 1);

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

      final countQuery = (memdb.selectOnly(memdb.transactions)
            ..addColumns([d.countAll()]))
          .map((r) => r.read(d.countAll()));

      int count = 0;
      final Completer resultCompleter = Completer();
      containerForReceiver.listen(
        resultNotifierProvider(25),
        (prev, after) {
          count++;
          if (count == 3) resultCompleter.complete();
        },
      );
      await resultCompleter.future;
      final rowCount = await countQuery.getSingle();
      expect(rowCount, 25, reason: ' should have 25 rows in table');
    });
  });
}
