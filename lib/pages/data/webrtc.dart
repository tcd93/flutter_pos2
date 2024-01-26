import 'package:flutter_pos/mdns/bonjour.dart';
import 'package:flutter_pos/p2p/manager.dart';
import 'package:flutter_pos/p2p/syncer.dart';
import 'package:flutter_pos/pages/data/db.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:logging/logging.dart';
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
  List<String?> build() {
    return ref.watch(serviceProvider.select((srv) => srv.displayLabels));
  }
}

@Riverpod(keepAlive: true)
class PeerConnectionState extends _$PeerConnectionState {
  @override
  RTCPeerConnectionState? build() => null;
  set(RTCPeerConnectionState newState) => state = newState;
}

@Riverpod(keepAlive: true)
class Service extends _$Service {
  final _logger = Logger('Service Provider');

  @override
  WebRtcManager build() {
    final bonjour = Bonjour();
    return WebRtcManager(
      onChannelState: onChannelState,
      onMessage: onMessage,
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

  void onMessage(RTCDataChannel channel, String message) async {
    final db = ref.read(dbProvider);
    Syncer(db).processMessage(
      message,
      onTransactionSyncComplete: () {
        state.sendTo(channel, Syncer.acknowledge());
        ref.read(syncDoneNotifierProvider(channel.label!).notifier).done();
      },
      onAcknowledge: () {
        _logger.info('Sync acknowledged for channel: ${channel.label}');
        ref.read(syncDoneNotifierProvider(channel.label!).notifier).done();
      },
    );
  }

  void onPeerConnectionState(RTCPeerConnectionState state) {
    ref.read(peerConnectionStateProvider.notifier).set(state);
  }
}

@riverpod
class SyncDoneNotifier extends _$SyncDoneNotifier {
  @override
  bool build(String channelLabel) => false;

  void done() => state = true;
}
