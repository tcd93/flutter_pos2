import 'dart:convert';
import 'dart:io';

import 'package:flutter_pos/p2p/channel.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:http/http.dart' as http;

class AddHttps extends HttpOverrides {
  String certFile;

  AddHttps(this.certFile);

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    if (context == null) {
      context = SecurityContext();
      context.setTrustedCertificates(certFile);
    }
    return super.createHttpClient(context);
  }
}

/// https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API/Connectivity#signaling
mixin Receiver on Channel {
  Future<void> createChannel(String host, String label) async {
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

    final cert = Platform.script.resolve('assets/certs/cert.pem').toFilePath();
    HttpOverrides.global = AddHttps(cert);

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

  Future<String?> _requestOffer(String ipAddress, String? label) async {
    final response = await http.get(Uri.https('${ipAddress}:50001', '', {
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
      Uri.https('${ipAddress}:50001'),
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
      Uri.https('${ipAddress}:50001', 'add-candidate'),
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
