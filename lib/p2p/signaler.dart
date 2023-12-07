import 'dart:convert';
import 'dart:io';

import 'package:flutter_pos/p2p/channel.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class ServerAlreadyRunningException implements Exception {
  final String cause;

  ServerAlreadyRunningException([String? cause])
      : this.cause = cause ?? 'Server is already running';
}

/// https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API/Connectivity#signaling
mixin Signaler on Channel {
  /// Temporary communication server (STUN server of sort) to establish p2p connection
  HttpServer? _server;

  bool get hosting => _server != null;

  Future<void> closeServer() async {
    await _server?.close(force: true);
    _server = null;
    onHostingCallback(false);
  }

  void onHostingCallback(bool status);

  Future<void> startServer([
    String? certFile,
    String? keyFile,
    int port = 50001,
  ]) async {
    if (_server != null) {
      throw ServerAlreadyRunningException();
    }

    if (certFile != null && keyFile != null) {
      var context = SecurityContext()
        ..useCertificateChain(certFile)
        ..usePrivateKey(keyFile);

      _server = await HttpServer.bindSecure(
          InternetAddress.anyIPv4, port, context,
          requestClientCertificate: true);
    } else {
      _server = await HttpServer.bind(InternetAddress.anyIPv4, port);
    }
    onHostingCallback(true);

    final sv = _server!;
    print(
      'Server running on IP : ${sv.address.toString()} on port ${sv.port}',
    );

    Future.microtask(() async {
      await for (final request in sv) {
        final path = request.uri.path;
        switch (request.method) {
          case 'GET':
            {
              switch (path) {
                case '/':
                  _handleIncoming(request);
                case '/test':
                  request.response
                    ..statusCode = HttpStatus.ok
                    ..headers.add('Access-Control-Allow-Origin', '*')
                    ..close();
              }
            }
          case 'POST':
            {
              switch (path) {
                case '/':
                  _handleAnswer(request);
                case '/add-candidate':
                  _handleAddCandidate(request);
              }
            }
        }
      }
    });
  }

  Future<RTCSessionDescription> _createOffer(
    RTCPeerConnection peer,
    String label,
  ) async {
    // set up data channel before creating offer
    final dc = await peer.createDataChannel(label, RTCDataChannelInit());
    connections.add(dc);

    dc.onDataChannelState = (state) async {
      if (state == RTCDataChannelState.RTCDataChannelOpen ||
          state == RTCDataChannelState.RTCDataChannelClosed) {
        await closeServer();
      }
      if (state == RTCDataChannelState.RTCDataChannelClosed) {
        connections.remove(dc);
      }
      onChannelState?.call(dc);
    };
    dc.onMessage = (message) {
      this.onMessage?.call(dc, message.text);
    };

    final offer = await peer.createOffer();
    peer.setLocalDescription(offer);
    return offer;
  }

  /// If for some reason ICE trickle doesn't work
  void _handleAddCandidate(HttpRequest request) async {
    String message = '';
    int statusCode = HttpStatus.ok;
    try {
      final body = await utf8.decoder.bind(request).join();
      final json = jsonDecode(body);
      final peer = validatePeer(json['label']);
      await peer.addCandidate(RTCIceCandidate(
        json['candidate'],
        json['sdpMid'],
        json['sdpMLineIndex'],
      ));
      message = 'Candidate added successfully';
    } catch (ex) {
      statusCode = HttpStatus.badRequest;
      message = ex.toString();
    } finally {
      request.response
        ..statusCode = statusCode
        ..headers.add('Access-Control-Allow-Origin', '*')
        ..write(message)
        ..close();
    }
  }

  void _handleAnswer(HttpRequest request) async {
    String message = '';
    int statusCode = HttpStatus.ok;
    try {
      final body = await utf8.decoder.bind(request).join();
      final json = jsonDecode(body);
      final peer = validatePeer(json['label']);
      await peer.setRemoteDescription(
        RTCSessionDescription(json['answer'], 'answer'),
      );
      message = 'Remote description set';
    } catch (ex) {
      statusCode = HttpStatus.badRequest;
      message = ex.toString();
    } finally {
      request.response
        ..statusCode = statusCode
        ..headers.add('Access-Control-Allow-Origin', '*')
        ..write(message)
        ..close();
    }
  }

  /// Incoming connection request from connector.dart
  void _handleIncoming(HttpRequest request) async {
    RTCSessionDescription? offer;
    String? message;
    int status = HttpStatus.ok;
    final label = request.uri.queryParameters['label'];
    if (label == null) {
      message = '[label] query parameter not set';
      status = HttpStatus.badRequest;
    } else if (connections.where((c) => c.label == label).isNotEmpty) {
      message = '${label} already set in host\'s connection list';
      status = HttpStatus.badRequest;
    } else {
      try {
        final peer = await createPeer(label);
        offer = await _createOffer(peer, label);
      } catch (ex) {
        status = HttpStatus.conflict;
        message = ex.toString();
      }
    }
    request.response
      ..headers.contentType = ContentType('text', 'plain', charset: 'utf-8')
      /*required to work with get requests from browser, do not remove*/
      ..headers.add('Access-Control-Allow-Origin', '*')
      ..headers.add('Access-Control-Allow-Methods', 'GET,POST')
      ..headers.add('Access-Control-Allow-Headers', 'X-Requested-With')
      ..statusCode = status
      ..write(offer?.sdp ?? message)
      ..close();
  }
}
