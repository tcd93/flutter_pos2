import 'package:flutter_pos/mdns/bonjour.dart';
import 'package:flutter_pos/p2p/channel.dart';
import 'package:flutter_pos/p2p/receiver.dart';
import 'package:flutter_pos/p2p/signaler.dart';
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
    final role = ref.watch(roleProvider);
    return switch (role) {
      Profile.signaler => ref.read(signalServiceProvider).displayLabel,
      Profile.receiver => ref.read(receiverServiceProvider).displayLabel,
      _ => null,
    };
  }
}

@Riverpod(keepAlive: true)
class PeerConnectionState extends _$PeerConnectionState {
  @override
  RTCPeerConnectionState? build() => null;
  set(RTCPeerConnectionState newState) => state = newState;
}

@Riverpod(keepAlive: true)
class ReceiverService extends _$ReceiverService {
  @override
  Receiver build() {
    return Receiver(
      onChannelState: (dc) {
        // recalculate labels on channel state change
        ref.invalidate(labelProvider);
      },
      onPeerConnectionState: (state) {
        ref.read(peerConnectionStateProvider.notifier).set(state);
      },
    );
  }
}

@Riverpod(keepAlive: true)
class Role extends _$Role {
  @override
  Profile build() => Profile.none;

  set(Profile profile) => state = profile;
}

@Riverpod(keepAlive: true)
class SignalService extends _$SignalService {
  @override
  Signaler build() {
    final bonjour = Bonjour();
    return Signaler(
      onChannelState: (dc) {
        // recalculate labels on channel state change
        ref.invalidate(labelProvider);
      },
      onPeerConnectionState: (state) {
        ref.read(peerConnectionStateProvider.notifier).set(state);
      },
      onHosting: (hosting) {
        ref.read(hostStatusProvider.notifier).set(hosting);
        hosting ? bonjour.broadcast() : bonjour.stopBroadcast();
      },
    );
  }
}
