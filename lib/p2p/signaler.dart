import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_pos/p2p/channel.dart';
import 'package:flutter_pos/p2p/security.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class ServerAlreadyRunningException implements Exception {
  final String cause;

  ServerAlreadyRunningException([String? cause])
      : this.cause = cause ?? 'Server is already running';
}

/// https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API/Connectivity#signaling
mixin Signaler on Channel {
  /// Temporary communication server (STUN server of sort) to establish p2p connection
  /// When starting the server it'll ask for a passphrase
  /// When client connect to server it'll also ask for a passphrase to verify
  HttpServer? _server;

  bool get hosting => _server != null;

  Future<void> closeServer() async {
    await _server?.close(force: true);
    _server = null;
    onHostingCallback(false);
  }

  void onHostingCallback(bool status);

  /// [key] is a 16-length secret for AES decryption
  Future<void> startServer({
    required String passphrase,
    int port = 50001,
  }) async {
    if (_server != null) {
      throw ServerAlreadyRunningException();
    }
    _server = await HttpServer.bind(InternetAddress.anyIPv4, port);
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
                  bool valid = await _verifyPassphrase(request, passphrase);
                  if (valid) _handleIncoming(request, passphrase);
                case '/test':
                  bool valid = await _verifyPassphrase(request, passphrase);
                  if (valid) {
                    request.response
                      ..headers.contentType =
                          ContentType('text', 'plain', charset: 'utf-8')
                      ..statusCode = HttpStatus.ok
                      ..write('test request received')
                      ..close();
                  }
                default:
                  _handleInvalid(request);
              }
            }
          case 'POST':
            {
              switch (path) {
                case '/':
                  _handleAnswer(request, passphrase);
                case '/add-candidate':
                  _handleAddCandidate(request);
                default:
                  _handleInvalid(request);
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
      super.onRawMessage(dc, message.text);
    };

    final offer = await peer.createOffer();
    peer.setLocalDescription(offer);
    return offer;
  }

  /// If for some reason ICE trickle doesn't work
  void _handleAddCandidate(HttpRequest request) async {
    String message = '';
    int statusCode = HttpStatus.ok;
    String stack = '';

    final body = await utf8.decoder.bind(request).join();
    final json = jsonDecode(body);

    if (json['label'] == null) {
      message = '[label] query parameter not set';
      statusCode = HttpStatus.badRequest;
    } else {
      try {
        final peer = validatePeer(json['label']);
        await peer.addCandidate(RTCIceCandidate(
          json['candidate'],
          json['sdpMid'],
          json['sdpMLineIndex'],
        ));
      } catch (ex, trace) {
        statusCode = HttpStatus.internalServerError;
        if (kDebugMode || Platform.environment.containsKey('FLUTTER_TEST')) {
          message = ex.toString();
          stack = trace.toString();
        }
      }
    }

    statusCode = HttpStatus.ok;
    message = 'Candidate added successfully';
    request.response
      ..statusCode = statusCode
      ..headers.add('Access-Control-Allow-Origin', '*')
      ..write(message)
      ..write(stack)
      ..close();
  }

  void _handleAnswer(HttpRequest request, String serverPassphrase) async {
    String message = '';
    int statusCode = HttpStatus.ok;
    String stack = '';

    final body = await utf8.decoder.bind(request).join();
    final json = jsonDecode(body);

    final encoded = EncodedMessage.fromJson(json);
    if (encoded == null) {
      statusCode = HttpStatus.badRequest;
      message = 'Query param not valid';
    } else {
      try {
        final answer = encoded.decode(serverPassphrase);
        final peer = validatePeer(json['label']);
        await peer.setRemoteDescription(
          RTCSessionDescription(answer.raw, 'answer'),
        );
      } catch (ex, trace) {
        statusCode = HttpStatus.internalServerError;
        if (kDebugMode || Platform.environment.containsKey('FLUTTER_TEST')) {
          message = ex.toString();
          stack = trace.toString();
        }
      }
    }

    statusCode = HttpStatus.ok;
    message = 'Remote description set';
    request.response
      ..statusCode = statusCode
      ..headers.add('Access-Control-Allow-Origin', '*')
      ..write(message)
      ..write(stack)
      ..close();
  }

  /// Incoming connection request from connector.dart
  void _handleIncoming(HttpRequest request, String passphrase) async {
    RTCSessionDescription? offer;
    Map<String, String> body = {};
    int status = HttpStatus.ok;
    final label = request.uri.queryParameters['label'];
    if (label == null) {
      body = {'message': '[label] query parameter not set'};
      status = HttpStatus.badRequest;
    } else if (connections.where((c) => c.label == label).isNotEmpty) {
      body = {'message': '${label} already set in host\'s connection list'};
      status = HttpStatus.badRequest;
    } else {
      try {
        final peer = await createPeer(label);
        offer = await _createOffer(peer, label);
      } catch (ex) {
        status = HttpStatus.conflict;
        body = {'message': ex.toString()};
      }
    }

    if (offer?.sdp != null) {
      body =
          RawMessage(offer!.sdp!, EncodeType.offer).encode(passphrase).toJson();
    }

    request.response
      ..headers.contentType = ContentType('text', 'plain', charset: 'utf-8')
      /*required to work with get requests from browser, do not remove*/
      ..headers.add('Access-Control-Allow-Origin', '*')
      ..headers.add('Access-Control-Allow-Methods', 'GET,POST')
      ..headers.add('Access-Control-Allow-Headers', 'X-Requested-With')
      ..statusCode = status
      ..write(jsonEncode(body))
      ..close();
  }

  void _handleInvalid(HttpRequest request) {
    request.response
      ..statusCode = HttpStatus.badRequest
      ..close();
  }

  Future<bool> _verifyPassphrase(
    HttpRequest request,
    String serverPassphrase,
  ) async {
    String message = '';
    int statusCode = HttpStatus.ok;
    String stack = '';

    final encoded = EncodedMessage.fromJson(request.uri.queryParameters);
    if (encoded == null) {
      message = 'Query param is not valid';
      statusCode = HttpStatus.badRequest;
    } else {
      try {
        final passphrase = encoded.decode(serverPassphrase).raw;
        if (passphrase != serverPassphrase) {
          message = '[passphrase] is not valid';
          statusCode = HttpStatus.unauthorized;
        }
      } catch (ex, trace) {
        statusCode = HttpStatus.internalServerError;
        if (kDebugMode || Platform.environment.containsKey('FLUTTER_TEST')) {
          message = ex.toString();
          stack = trace.toString();
        }
      }
    }

    if (statusCode != HttpStatus.ok) {
      final response = request.response
        ..headers.contentType = ContentType('text', 'plain', charset: 'utf-8')
        ..statusCode = statusCode
        ..write(message)
        ..write(stack);
      await response.close();
      return false;
    }

    return true;
  }
}
