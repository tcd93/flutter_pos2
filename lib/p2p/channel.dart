import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

abstract class Channel {
  void Function(RTCPeerConnectionState state)? onConnectionState;
  void Function(RTCDataChannel state)? onChannelState;
  void Function(RTCDataChannel channel, String message)? onMessage;

  final List<RTCPeerConnection> _peers = [];

  @visibleForTesting
  @protected
  List<RTCDataChannel> connections = [];

  Channel({this.onChannelState, this.onConnectionState, this.onMessage});

  List<String?> get displayLabels {
    return connections.map((c) => c.label).toList();
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
      onConnectionState?.call(s);
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

  void onRawMessage(RTCDataChannel channel, String text) {
    onMessage?.call(channel, text);
  }

  Future send(String text) async {
    List<Future<void>> futures = [];
    for (final conn in connections) {
      futures.add(conn.send(RTCDataChannelMessage(text)));
    }
    return Future.wait(futures);
  }

  Future sendTo(RTCDataChannel channel, String text) async {
    await channel.send(RTCDataChannelMessage(text));
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
      : cause = cause ?? 'Data channel has not been created yet';
}

class PeerNotCreatedException implements Exception {
  final String cause;

  PeerNotCreatedException([String? cause])
      : cause = cause ?? 'Peer has not been created yet';
}
