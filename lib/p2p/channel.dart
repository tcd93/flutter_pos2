import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

typedef Role = Profile;

mixin Channel {
  List<RTCPeerConnection> _peers = [];

  @visibleForTesting
  @protected
  List<RTCDataChannel> connections = [];

  String? get displayLabel {
    return connections.map((c) => c.label).join('; ');
  }

  /// Label must match channel name when calling [Receiver.createChannel]
  Future<RTCPeerConnection> createPeer(String label) async {
    final config = {
      'iceServers': [],
      'peerIdentity': label,
    };
    final peer = await createPeerConnection(config);
    // Due to maybe a bug, have to call setConfiguration again
    // to persist configuration setting on RTCPeerConnectionWeb
    peer.setConfiguration(config);
    _peers.add(peer);
    peer.onConnectionState = (s) async {
      if (s == RTCPeerConnectionState.RTCPeerConnectionStateDisconnected) {
        _peers.remove(peer);
      }
      onPeerConnectionState(s);
    };
    return peer;
  }

  Future<void> disconnect() async {
    for (final dc in connections) {
      final label = dc.label;
      await dc.close();
      await disconnectPeer(label!);
    }
    connections = [];
  }

  Future<void> disconnectPeer(String label) async {
    final peer = validatePeer(label);
    await peer.close();
    return peer.dispose();
  }

  void onPeerConnectionState(RTCPeerConnectionState state);

  Future send(String message) {
    List<Future<void>> futures = [];
    for (final conn in connections) {
      futures.add(conn.send(RTCDataChannelMessage(message)));
    }
    return Future.wait(futures);
  }

  @protected
  RTCDataChannel validateChannel(String channelName) {
    final dc = connections.firstWhereOrNull((con) => con.label == channelName);
    if (dc == null) {
      throw ChannelNotCreatedException();
    }
    return dc;
  }

  @protected
  RTCPeerConnection validatePeer(String identity) {
    final peer = _peers.firstWhereOrNull(
      (peer) => peer.getConfiguration['peerIdentity'] == identity,
    );
    if (peer == null) {
      throw PeerNotCreatedException();
    }
    return peer;
  }
}

class ChannelNotCreatedException implements Exception {
  final String cause;

  ChannelNotCreatedException([String? cause])
      : this.cause = cause ?? 'Data channel has not been created yet';
}

class PeerNotCreatedException implements Exception {
  final String cause;

  PeerNotCreatedException([String? cause])
      : this.cause = cause ?? 'Peer has not been created yet';
}

enum Profile {
  /// 1st peer in a p2p connection that also hosts a httpserver for [receiver] to find and connect to
  signaler,

  /// 2nd peer in a p2p connection
  receiver,

  none,
}
