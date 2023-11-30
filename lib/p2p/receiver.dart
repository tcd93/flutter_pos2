import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_pos/p2p/channel.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:http/http.dart' as http;

/// https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API/Connectivity#signaling
class Receiver with Channel {
  void Function(RTCPeerConnectionState state)? onConnectionState;
  void Function(RTCDataChannel state)? onChannelState;
  void Function(String message)? onMessage;

  @visibleForTesting
  RTCDataChannel? dc;

  Receiver({
    void Function(RTCPeerConnectionState state)? onPeerConnectionState,
    this.onChannelState,
    this.onMessage,
  }) : onConnectionState = onPeerConnectionState;

  @override
  String? get displayLabel {
    return dc?.label;
  }

  Future<void> createChannel(String host, String label) async {
    final peer = await createPeer(label);

    peer.onDataChannel = (channel) {
      if (channel.label == label) {
        dc = channel;
        channel.onDataChannelState = (state) {
          if (state == RTCDataChannelState.RTCDataChannelClosed) {
            dc = null;
          }
          onChannelState?.call(channel);
        };
        channel.onMessage = (message) {
          this.onMessage?.call(message.text);
        };
      }
    };

    final sdp = await _requestOffer(host, label);

    await peer.setRemoteDescription(RTCSessionDescription(sdp, 'offer'));
    final answer = await peer.createAnswer();

    await _sendBackAnswer(host, label, answer.sdp!);

    peer.onIceCandidate = (candidate) async {
      print('onIceCandidate ${candidate.candidate}');
      await _sendCandidate(host, label, candidate);
    };

    // triggers onIceCandidate
    await peer.setLocalDescription(answer);
  }

  @override
  Future<void> disconnect() async {
    if (dc != null) {
      await dc!.close();
      await disconnectPeer(dc!.label!);
      dc = null;
    }
  }

  @override
  void onPeerConnectionState(RTCPeerConnectionState state) {
    onConnectionState?.call(state);
  }

  @override
  RTCDataChannel validateChannel(String channelName) {
    if (dc == null) {
      throw ChannelNotCreatedException();
    }
    assert(dc!.label == channelName);
    return dc!;
  }

  Future<String?> _requestOffer(String ipAddress, String? label) async {
    final response = await http.get(Uri.http('${ipAddress}:50001', '', {
      'label': label,
    }));
    assert(response.statusCode == HttpStatus.ok);
    return response.body;
  }

  Future<void> _sendBackAnswer(
    String ipAddress,
    String label,
    String sdp,
  ) async {
    final response = await http.post(
      Uri.http('${ipAddress}:50001'),
      body: jsonEncode({
        'label': label,
        'answer': sdp,
      }),
    );
    assert(response.statusCode == HttpStatus.ok);
  }

  Future<void> _sendCandidate(
    String ipAddress,
    String label,
    RTCIceCandidate candidate,
  ) async {
    final response = await http.post(
      Uri.http('${ipAddress}:50001', 'add-candidate'),
      body: jsonEncode({
        'label': label,
        'candidate': candidate.candidate,
        'sdpMid': candidate.sdpMid,
        'sdpMLineIndex': candidate.sdpMLineIndex,
      }),
    );
    assert(response.statusCode == HttpStatus.ok);
  }
}
