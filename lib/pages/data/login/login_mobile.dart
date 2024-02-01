import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_pos/pages/data/login/login.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_mobile.g.dart';

final _logger = Logger('Login');

@riverpod
class LoginMobile extends _$LoginMobile implements Login {
  void _checkKeys() {
    assert(kIsWeb == false);
    if (!dotenv.env.containsKey('NATIVE_AUTH0_DOMAIN') ||
        dotenv.env['NATIVE_AUTH0_DOMAIN']!.isEmpty) {
      _logger.shout(
          'Please set key NATIVE_AUTH0_DOMAIN in project .env file, for details '
          'see https://auth0.com/docs/quickstart/native/flutter/interactive');
      throw 'Please set key NATIVE_AUTH0_DOMAIN in project .env file';
    }
    if (!dotenv.env.containsKey('NATIVE_AUTH0_CLIENTID') ||
        dotenv.env['NATIVE_AUTH0_CLIENTID']!.isEmpty) {
      _logger.shout(
          'Please set key NATIVE_AUTH0_CLIENTID in project .env file, for details '
          'see https://auth0.com/docs/quickstart/native/flutter/interactive');
      throw 'Please set key NATIVE_AUTH0_CLIENTID in project .env file';
    }
  }

  @override
  Future<Credentials?> build() async {
    _checkKeys();

    _logger.info(
      'Initialize auth0 with domain ${dotenv.env['NATIVE_AUTH0_DOMAIN']}',
    );
    final auth0 = Auth0(
      dotenv.env['NATIVE_AUTH0_DOMAIN']!,
      dotenv.env['NATIVE_AUTH0_CLIENTID']!,
    );
    // if credentials are already stored, return them
    if (await auth0.credentialsManager.hasValidCredentials()) {
      return auth0.credentialsManager.credentials();
    }
    return null;
  }

  void _clearErrors() {
    _logger.info('Clear Errors');
    state = const AsyncData(null);
  }

  @override
  Future<bool> login({
    String? usernameOrEmail,
    String? password,
  }) async {
    assert(usernameOrEmail != null);
    assert(password != null);

    state = const AsyncLoading();

    final auth0 = Auth0(
      dotenv.env['NATIVE_AUTH0_DOMAIN']!,
      dotenv.env['NATIVE_AUTH0_CLIENTID']!,
    );
    try {
      final credentials = await auth0.api.login(
        usernameOrEmail: usernameOrEmail!,
        password: password!,
        connectionOrRealm: 'Username-Password-Authentication',
      );
      final didStore =
          await auth0.credentialsManager.storeCredentials(credentials);
      if (didStore) {
        _logger.info('Credentials stored');
      }
      state = AsyncData(credentials);
      return true;
    } on Exception catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      Future.delayed(const Duration(seconds: 5), _clearErrors);
      if (!error.toString().contains('authentication_canceled')) {
        rethrow;
      }
    }
    return false;
  }

  @override
  Future<bool> logout() async {
    final auth0 = Auth0(
      dotenv.env['NATIVE_AUTH0_DOMAIN']!,
      dotenv.env['NATIVE_AUTH0_CLIENTID']!,
    );
    state = const AsyncLoading();
    final cleared = await auth0.credentialsManager.clearCredentials();
    if (cleared) {
      _logger.info('Credentials cleared');
      state = const AsyncData(null);
      return true;
    } else {
      state = AsyncError('Failed to clear credentials', StackTrace.current);
    }
    return false;
  }
}
