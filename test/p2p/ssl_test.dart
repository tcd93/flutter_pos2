import 'dart:io';

import 'package:flutter_pos/p2p/manager.dart';
import 'package:flutter_pos/p2p/receiver.dart';
import 'package:flutter_pos/p2p/signaler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

//command to generate cert
//openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -sha256 -days 3650 -nodes

void main() {
  Signaler signaler = WebRtcManager();
  final cert = Platform.script.resolve('test/p2p/cert.pem').toFilePath();
  final cert2 = Platform.script.resolve('test/p2p/cert_no_cn.pem').toFilePath();
  final key = Platform.script.resolve('test/p2p/key.pem').toFilePath();
  final key2 = Platform.script.resolve('test/p2p/key_no_cn.pem').toFilePath();

  tearDown(() async => await signaler.closeServer());

  test('Test https by sending valid self-signed cert', () async {
    await signaler.startServer(cert, key);
    HttpOverrides.global = AddHttps(cert);
    final response = await http.get(Uri.https('localhost:50001', '/test'));
    expect(response.statusCode, HttpStatus.ok);
  });

  test('Test https by sending non-valid self-signed cert', () async {
    await signaler.startServer(cert, key);

    HttpOverrides.global = AddHttps(cert2);
    expect(http.get(Uri.https('localhost:50001', '/test')), throwsException);
  });

  // TODO: make this work!
  test('Test server able to use cert without CN', () async {
    await signaler.startServer(cert2, key2);

    HttpOverrides.global = AddHttps(cert2);
    // throws IP/hostname address mismatch
    await http.get(Uri.https('localhost:50001', '/test'));
  });
}
