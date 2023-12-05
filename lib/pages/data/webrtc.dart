import 'dart:convert';

import 'package:flutter_pos/mdns/bonjour.dart';
import 'package:flutter_pos/p2p/manager.dart';
import 'package:flutter_pos/p2p/syncer.dart';
import 'package:flutter_pos/pages/data/db.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'webrtc.g.dart';

@Riverpod(keepAlive: true)
class HostStatus extends _$HostStatus {
  @override
  bool build() => false;

  set(bool hosting) => state = hosting;
}

@Riverpod(keepAlive: true)
class Label extends _$Label {
  @override
  String? build() {
    return ref.watch(serviceProvider).displayLabel;
  }
}

@Riverpod(keepAlive: true)
class PeerConnectionState extends _$PeerConnectionState {
  @override
  RTCPeerConnectionState? build() => null;
  set(RTCPeerConnectionState newState) => state = newState;
}

@riverpod
class ResultNotifier extends _$ResultNotifier {
  add(int processed) {
    state = state + processed;
    if (count == state) {
      // TODO: notify done
      print('transactions complete!');
    }
  }

  @override
  int build(int count) => 0;
}

@Riverpod(keepAlive: true)
class Service extends _$Service {
  @override
  WebRtcManager build() {
    final bonjour = Bonjour();
    return WebRtcManager(
      onChannelState: onChannelState,
      onMessage: (channel, message) => onMessage(message),
      onConnectionState: onPeerConnectionState,
      onHosting: (hosting) {
        ref.read(hostStatusProvider.notifier).set(hosting);
        hosting ? bonjour.broadcast() : bonjour.stopBroadcast();
      },
    );
  }

  void onChannelState(RTCDataChannel dc) {
    // recalculate labels on channel state change
    ref.invalidate(labelProvider);
  }

  void onMessage(String message) async {
    final db = ref.read(dbProvider);
    int? result;
    try {
      final json = jsonDecode(message);
      final type = Syncer.getType(json);

      switch (type) {
        case 'Transaction':
          final count = Syncer.getCount(json);
          result = await Syncer().syncTransactions(db, json);
          ref.read(resultNotifierProvider(count).notifier).add(result ?? 0);
      }
    } on InvalidJsonFormatException catch (ex) {
      print(ex);
    } on FormatException catch (ex, stack) {
      print('Error in json decoding: $ex');
      print(stack);
      throw ex;
    }
  }

  void onPeerConnectionState(RTCPeerConnectionState state) {
    ref.read(peerConnectionStateProvider.notifier).set(state);
  }
}
