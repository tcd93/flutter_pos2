import 'package:flutter_pos/mdns/bonjour.dart';
import 'package:flutter_pos/p2p/channel.dart';
import 'package:flutter_pos/p2p/receiver.dart';
import 'package:flutter_pos/p2p/signaler.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'webrtc.g.dart';

@Riverpod(keepAlive: true)
class ConnectionState extends _$ConnectionState {
  @override
  RTCDataChannelState? build() => null;

  set(RTCDataChannelState newState) => state = newState;
}

@Riverpod(keepAlive: true)
class HostStatus extends _$HostStatus {
  @override
  bool build() => false;

  set(bool hosting) => state = hosting;
}

@Riverpod(keepAlive: true)
class Label extends _$Label {
  @override
  String? build() => null;

  set(String? label) => state = label;
}

@Riverpod(keepAlive: true)
class ReceiverService extends _$ReceiverService {
  @override
  Receiver build() {
    return Receiver(
      onChannelState: (state) {
        print('Receiver: onChannelState: $state');
        ref.read(connectionStateProvider.notifier).set(state);
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
        print('Signaler: onChannelState for channel ${dc.label}: ${dc.state}');
        ref.read(connectionStateProvider.notifier).set(dc.state!);
      },
      onHosting: (hosting) {
        ref.read(hostStatusProvider.notifier).set(hosting);
        hosting ? bonjour.broadcast() : bonjour.stopBroadcast();
      },
    );
  }
}
