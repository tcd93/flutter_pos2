import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:auth0_flutter/auth0_flutter_web.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_pos/pages/data/login/login.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_web.g.dart';

final _logger = Logger('Login');

@riverpod
class LoginWeb extends _$LoginWeb implements Login {
  void _checkKeys() {
    assert(kIsWeb == true);

    if (!dotenv.env.containsKey('WEB_AUTH0_DOMAIN') ||
        dotenv.env['WEB_AUTH0_DOMAIN']!.isEmpty) {
      _logger.shout(
          'Please set key WEB_AUTH0_DOMAIN in project .env file, for details '
          'see https://auth0.com/docs/quickstart/native/flutter/interactive');
      throw 'Please set key WEB_AUTH0_DOMAIN in project .env file';
    }
    if (!dotenv.env.containsKey('WEB_AUTH0_CLIENTID') ||
        dotenv.env['WEB_AUTH0_CLIENTID']!.isEmpty) {
      _logger.shout(
          'Please set key WEB_AUTH0_CLIENTID in project .env file, for details '
          'see https://auth0.com/docs/quickstart/native/flutter/interactive');
      throw 'Please set key WEB_AUTH0_CLIENTID in project .env file';
    }
  }

  @override
  Future<Credentials?> build() async {
    _checkKeys();

    _logger.info(
      'Initialize auth0 with domain ${dotenv.env['WEB_AUTH0_DOMAIN']}'
      ' and client ${dotenv.env['WEB_AUTH0_CLIENTID']}',
    );
    final auth0 = Auth0Web(
      dotenv.env['WEB_AUTH0_DOMAIN']!,
      dotenv.env['WEB_AUTH0_CLIENTID']!,
    );
    return auth0.onLoad();
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
    state = const AsyncLoading();

    final auth0 = Auth0Web(
      dotenv.env['WEB_AUTH0_DOMAIN']!,
      dotenv.env['WEB_AUTH0_CLIENTID']!,
    );
    try {
      await auth0.loginWithRedirect(
        redirectUrl: dotenv.env['WEB_AUTH0_REDIRECT_URL'],
      );
      return true;
    } on Exception catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      Future.delayed(const Duration(seconds: 5), _clearErrors);
      if (!error.toString().contains('POPUP_CLOSED')) {
        rethrow;
      }
    }
    return false;
  }

  @override
  Future<bool> logout() async {
    final auth0 = Auth0Web(
      dotenv.env['WEB_AUTH0_DOMAIN']!,
      dotenv.env['WEB_AUTH0_CLIENTID']!,
    );
    state = const AsyncLoading();
    await auth0.logout();
    state = const AsyncData(null);
    return true;
  }
}
