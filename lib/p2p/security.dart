import 'package:encrypt/encrypt.dart';
import 'package:logging/logging.dart';

final _logger = Logger('Security');

class EncodedMessage {
  final Encrypted encrypted;
  final IV iv;
  final EncodeType type;

  const EncodedMessage(this.encrypted, this.iv, this.type);

  RawMessage decode(String utf8key) {
    final key = utf8key.padLeft(16).substring(0, 16);
    final encrypter = Encrypter(AES(Key.fromUtf8(key), mode: AESMode.cbc));
    return RawMessage(encrypter.decrypt(encrypted, iv: iv), type);
  }

  Map<String, String> toJson() {
    return {
      'type': type.name,
      type.name: encrypted.base64,
      'iv': iv.base64,
    };
  }

  static EncodedMessage? fromJson(dynamic json) {
    try {
      final type = EncodeType.values.byName(json['type']);
      if (json[json['type']] == null || json['iv'] == null) {
        _logger.log(
          Level.SEVERE,
          'keys [iv] or ${json[json['type']]} not found',
        );
        return null;
      }
      final encrypted = Encrypted.fromBase64(json[json['type']]);
      final iv = IV.fromBase64(json['iv']);
      return EncodedMessage(encrypted, iv, type);
    } catch (ex) {
      _logger.log(Level.SEVERE, ex);
      return null;
    }
  }
}

enum EncodeType {
  passphrase,
  offer,
  answer,
}

class RawMessage {
  final String raw;
  IV? iv;
  final EncodeType type;

  RawMessage(this.raw, this.type);

  EncodedMessage encode(String utf8key) {
    // pad to 16 characters to fit 128bit
    final key = utf8key.padLeft(16).substring(0, 16);
    iv = IV.fromLength(key.length);
    final encryter = Encrypter(AES(Key.fromUtf8(key), mode: AESMode.cbc));
    return EncodedMessage(encryter.encrypt(raw, iv: iv!), iv!, type);
  }
}

/// valuable reads: https://www.highgo.ca/2019/08/08/the-difference-in-five-modes-in-the-aes-encryption-algorithm/
