import 'package:flutter_pos/p2p/channel.dart';
import 'package:flutter_pos/p2p/receiver.dart';
import 'package:flutter_pos/p2p/signaler.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class WebRtcManager extends Channel with Signaler, Receiver {
  void Function(bool hosting)? onHosting;

  WebRtcManager({
    int port = 50001,
    super.onConnectionState,
    Function(RTCDataChannel state)? super.onChannelState,
    super.onMessage,
    this.onHosting,
  });

  @override
  void onHostingCallback(bool status) {
    onHosting?.call(status);
  }
}
