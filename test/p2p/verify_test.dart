import 'dart:io';

import 'package:flutter_pos/p2p/manager.dart';
import 'package:flutter_pos/p2p/security.dart';
import 'package:flutter_pos/p2p/signaler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  Signaler signaler = WebRtcManager();

  tearDown(() async => await signaler.closeServer());

  test('Test security by sending valid passphrase', () async {
    final passphrase = '1234567890123456123456789012';
    await signaler.startServer(passphrase: passphrase);

    final response = await http.get(Uri.http(
      'localhost:50001',
      '/test',
      RawMessage(passphrase, EncodeType.passphrase).encode(passphrase).toJson(),
    ));
    expect(response.statusCode, HttpStatus.ok, reason: response.body);
  });

  test('Test security by sending invalid passphrase', () async {
    final passphrase = '1234567890123456123456789012';
    await signaler.startServer(passphrase: passphrase);

    final response = await http.get(Uri.http(
      'localhost:50001',
      '/test',
      RawMessage('nah-', EncodeType.passphrase).encode(passphrase).toJson(),
    ));
    expect(response.statusCode, HttpStatus.unauthorized, reason: response.body);
  });
}
