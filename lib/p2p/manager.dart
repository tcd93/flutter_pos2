import 'package:flutter_pos/p2p/channel.dart';
import 'package:flutter_pos/p2p/receiver.dart';
import 'package:flutter_pos/p2p/signaler.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class WebRtcManager extends Channel with Signaler, Receiver {
  void Function(bool hosting)? onHosting;

  WebRtcManager({
    int port = 50001,
    void Function(RTCPeerConnectionState state)? onConnectionState,
    Function(RTCDataChannel state)? onChannelState,
    void Function(RTCDataChannel channel, String message)? onMessage,
    this.onHosting,
  }) : super(
          onChannelState: onChannelState,
          onConnectionState: onConnectionState,
          onMessage: onMessage,
        );

  @override
  void onHostingCallback(bool status) {
    this.onHosting?.call(status);
  }
}
