import 'dart:convert';
import 'dart:io';

import 'package:flutter_pos/p2p/channel.dart';
import 'package:flutter_pos/p2p/security.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:http/http.dart' as http;

/// https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API/Connectivity#signaling
mixin Receiver on Channel {
  Future<void> createChannel(
    String host,
    String label,
    String passphrase,
  ) async {
    final peer = await createPeer(label);

    peer.onDataChannel = (channel) {
      if (channel.label == label) {
        connections.add(channel);
        channel.onDataChannelState = (state) {
          if (state == RTCDataChannelState.RTCDataChannelClosed) {
            connections.remove(channel);
          }
          onChannelState?.call(channel);
        };
        channel.onMessage = (message) {
          this.onMessage?.call(channel, message.text);
        };
      }
    };

    final json = await _requestOffer(host, label, passphrase);
    final encoded = EncodedMessage.fromJson(json);
    assert(encoded != null, 'invalid json returned from _requestOffer: $json');
    final sdp = encoded!.decode(passphrase).raw;

    await peer.setRemoteDescription(RTCSessionDescription(sdp, 'offer'));
    final answer = await peer.createAnswer();

    final encodedAnswer =
        RawMessage(answer.sdp!, EncodeType.answer).encode(passphrase);
    await _sendBackAnswer(host, label, encodedAnswer);

    peer.onIceCandidate = (candidate) async {
      print('onIceCandidate ${candidate.candidate}');
      await _sendCandidate(host, label, candidate);
    };

    // triggers onIceCandidate
    await peer.setLocalDescription(answer);
  }

  Future<Map<String, dynamic>> _requestOffer(
    String ipAddress,
    String label,
    String passphrase,
  ) async {
    Map<String, dynamic> requestParam = {'label': label};
    final decoded = RawMessage(passphrase, EncodeType.passphrase);
    requestParam = {
      ...requestParam,
      ...decoded.encode(passphrase).toJson(),
    };
    final response =
        await http.get(Uri.http('${ipAddress}:50001', '', requestParam));
    assert(response.statusCode == HttpStatus.ok, response.body);
    return jsonDecode(response.body);
  }

  Future<void> _sendBackAnswer(
    String ipAddress,
    String label,
    EncodedMessage answer,
  ) async {
    final response = await http.post(
      Uri.http('${ipAddress}:50001'),
      body: jsonEncode({
        'label': label,
        ...answer.toJson(),
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
