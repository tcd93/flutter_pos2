import 'dart:async';

import 'package:drift/drift.dart' as d;
import 'package:flutter_pos/database/drift_database.dart';
import 'package:flutter_pos/database/drift_database_test.dart';
import 'package:flutter_pos/p2p/channel.dart';
import 'package:flutter_pos/p2p/receiver.dart';
import 'package:flutter_pos/p2p/signaler.dart';
import 'package:flutter_pos/p2p/syncer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:integration_test/integration_test.dart';

//flutter drive --target=integration_test/p2p/channel.dart -d windows
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end (2 peers)', () {
    const String label = 'channel-1';
    late Signaler signaler;
    late Receiver receiver;
    Completer<RTCDataChannelState> channelStateCompleter = Completer();

    setUp(() async {
      signaler = Signaler();
      receiver = Receiver(onChannelState: (dc) {
        if (!channelStateCompleter.isCompleted)
          channelStateCompleter.complete(dc.state);
      });
    });

    tearDown(() async {
      await signaler.disconnect();
    });

    test('signal exchange successfully', () async {
      await signaler.startServer();
      await receiver.createChannel('localhost', label);
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
    late Signaler signaler;
    late Receiver receiver1;
    late Receiver receiver2;
    Completer<RTCDataChannelState> channelStateCompleter1 = Completer();
    Completer<RTCDataChannelState> channelStateCompleter2 = Completer();

    setUp(() async {
      signaler = Signaler();
      receiver1 = Receiver(
        onChannelState: (dc) {
          if (!channelStateCompleter1.isCompleted)
            channelStateCompleter1.complete(dc.state);
        },
      );
      receiver2 = Receiver(
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
      await signaler.startServer();
      await receiver1.createChannel('localhost', label1);
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
      await signaler.startServer();
      await receiver2.createChannel('localhost', label2);
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

  group('cross device data sync', () {
    const String label = 'channel';
    late Signaler signaler;
    late Receiver receiver;
    late TestingDriftDB memdb;
    final syncer = Syncer(type: Profile.receiver);
    Completer<RTCDataChannelState> channelStateCompleter = Completer();
    Completer<void> insertCompleter = Completer();

    setUp(() async {
      memdb = TestingDriftDB();
      signaler = Signaler();
      receiver = Receiver(
        onChannelState: (dc) {
          if (!channelStateCompleter.isCompleted)
            channelStateCompleter.complete(dc.state);
        },
        onMessage: (message) async {
          await syncer.sync(Profile.receiver, memdb, message);
          if (!insertCompleter.isCompleted) insertCompleter.complete();
        },
      );
      await signaler.startServer();
      await receiver.createChannel('localhost', label);
      await channelStateCompleter.future;

      await memdb.into(memdb.cardItems).insert(
          CardItemsCompanion.insert(id: d.Value(0), pageID: 0, title: 'test'));
    });

    tearDown(() async {
      await signaler.disconnect();
      await memdb.close();
    });

    test('send signal to insert new transaction in receiver', () async {
      final trx = Transaction(
        id: 100,
        cardID: 0,
        date: DateTime(2023, 30, 11),
        price: 100,
      );

      await signaler.send(label, syncer.wrap([trx]));
      await insertCompleter.future;

      final query = memdb.select(memdb.transactions)
        ..where((r) => r.id.equals(100));
      final row = await query.getSingle();
      expect(row, trx);
    });
  });
}
