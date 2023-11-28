import 'dart:async';

import 'package:flutter_pos/p2p/receiver.dart';
import 'package:flutter_pos/p2p/signaler.dart';
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
      receiver = Receiver(onChannelState: (state) {
        print('onChannelState $state');
        if (!channelStateCompleter.isCompleted)
          channelStateCompleter.complete(state);
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
        receiver.dc!.label,
        'channel-1',
        reason: 'channel should be named "${label}"',
      );
    });

    test('disconnect successfully from Signaler', () async {
      await signaler.disconnect();

      expect(signaler.connections, isEmpty);
      expect(receiver.dc, isNull);
    });

    test('disconnect successfully from Receiver', () async {
      await receiver.disconnect();

      expect(signaler.connections, isEmpty);
      expect(receiver.dc, isNull);
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
        onChannelState: (state) {
          print('receiver1 onChannelState $state');
          if (!channelStateCompleter1.isCompleted)
            channelStateCompleter1.complete(state);
        },
      );
      receiver2 = Receiver(
        onChannelState: (state) {
          print('receiver2 onChannelState $state');
          if (!channelStateCompleter2.isCompleted)
            channelStateCompleter2.complete(state);
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
        receiver1.dc!.label,
        label1,
        reason: 'channel should be named "${label1}"',
      );
      expect(
        receiver2.dc!.label,
        label2,
        reason: 'channel should be named "${label2}"',
      );
    });
  });
}
