import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:auth0_flutter/auth0_flutter_web.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login.g.dart';

final _logger = Logger('Login');

@riverpod
class Login extends _$Login {
  @override
  Future<Credentials?> build() {
    if (!dotenv.env.containsKey('WEB_AUTH0_DOMAIN')) {
      _logger.shout(
          'Please set key WEB_AUTH0_DOMAIN in project .env file, for details '
          'see https://auth0.com/docs/quickstart/native/flutter/interactive');
    }
    if (!dotenv.env.containsKey('WEB_AUTH0_CLIENTID')) {
      _logger.shout(
          'Please set key WEB_AUTH0_CLIENTID in project .env file, for details '
          'see https://auth0.com/docs/quickstart/native/flutter/interactive');
    }
    _logger
        .info('Initialize auth0 with domain ${dotenv.env['WEB_AUTH0_DOMAIN']}'
            ' and client ${dotenv.env['WEB_AUTH0_CLIENTID']}');

    final auth0 = Auth0Web(
      dotenv.env['WEB_AUTH0_DOMAIN']!,
      dotenv.env['WEB_AUTH0_CLIENTID']!,
    );

    return auth0.onLoad();
  }

  Future<void> login() async {
    if (kIsWeb) {
      final auth0 = Auth0Web(
        dotenv.env['WEB_AUTH0_DOMAIN']!,
        dotenv.env['WEB_AUTH0_CLIENTID']!,
      );
      state = const AsyncLoading();
      try {
        // bring up login webpage, after successful login this provider will
        // rebuilds, `auth0.onLoad()` now returns user credentials
        await auth0.loginWithRedirect(redirectUrl: 'http://localhost:3000');
      } on Exception catch (error, stackTrace) {
        if (!error.toString().contains('POPUP_CLOSED')) {
          _logger.severe(error);
          _logger.severe(stackTrace);
          rethrow;
        }
      }
    } else {
      //TODO: configure android
      Auth0(
        dotenv.env['ANDROID_AUTH0_DOMAIN']!,
        dotenv.env['ANDROID_AUTH0_DOMAIN']!,
      );
    }
  }

  Future<void> logout() async {
    if (kIsWeb) {
      final auth0 = Auth0Web(
        dotenv.env['WEB_AUTH0_DOMAIN']!,
        dotenv.env['WEB_AUTH0_CLIENTID']!,
      );
      state = const AsyncLoading();
      await auth0.logout();
      state = const AsyncData(null);
    } else {
      Auth0(
        dotenv.env['ANDROID_AUTH0_DOMAIN']!,
        dotenv.env['ANDROID_AUTH0_DOMAIN']!,
      );
    }
  }
}
