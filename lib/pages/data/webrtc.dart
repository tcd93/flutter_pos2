import 'package:flutter_pos/mdns/bonjour.dart';
import 'package:flutter_pos/p2p/channel.dart';
import 'package:flutter_pos/p2p/receiver.dart';
import 'package:flutter_pos/p2p/signaler.dart';
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
    return ref.watch(serviceProvider)?.displayLabel;
  }
}

@Riverpod(keepAlive: true)
class PeerConnectionState extends _$PeerConnectionState {
  @override
  RTCPeerConnectionState? build() => null;
  set(RTCPeerConnectionState newState) => state = newState;
}

@Riverpod(keepAlive: true)
class Role extends _$Role {
  @override
  Profile build() => Profile.none;

  set(Profile profile) => state = profile;
}

@Riverpod(keepAlive: true)
class Service extends _$Service {
  @override
  Channel? build() {
    final role = ref.watch(roleProvider);
    return switch (role) {
      Profile.signaler => ref.read(_signalServiceProvider),
      Profile.receiver => ref.read(_receiverServiceProvider),
      _ => null,
    };
  }
}

@Riverpod(keepAlive: true)
class _ReceiverService extends _$ReceiverService {
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
      onMessage: (message) {
        final role = ref.read(roleProvider);
        final db = ref.read(dbProvider);
        Syncer(type: role).sync(role, db, message);
      },
    );
  }
}

@Riverpod(keepAlive: true)
class _SignalService extends _$SignalService {
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
      onMessage: (dc, message) {
        final role = ref.read(roleProvider);
        final db = ref.read(dbProvider);
        Syncer(type: role).sync(role, db, message);
      },
    );
  }
}
