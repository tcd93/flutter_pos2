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
  Future<Credentials?> build() async {
    if (kIsWeb &&
        (!dotenv.env.containsKey('WEB_AUTH0_DOMAIN') ||
            dotenv.env['WEB_AUTH0_DOMAIN']!.isEmpty)) {
      _logger.shout(
          'Please set key WEB_AUTH0_DOMAIN in project .env file, for details '
          'see https://auth0.com/docs/quickstart/native/flutter/interactive');
      throw 'Please set key WEB_AUTH0_DOMAIN in project .env file';
    }
    if (kIsWeb &&
        (!dotenv.env.containsKey('WEB_AUTH0_CLIENTID') ||
            dotenv.env['WEB_AUTH0_CLIENTID']!.isEmpty)) {
      _logger.shout(
          'Please set key WEB_AUTH0_CLIENTID in project .env file, for details '
          'see https://auth0.com/docs/quickstart/native/flutter/interactive');
      throw 'Please set key WEB_AUTH0_CLIENTID in project .env file';
    }
    if (!kIsWeb &&
        (!dotenv.env.containsKey('NATIVE_AUTH0_DOMAIN') ||
            dotenv.env['NATIVE_AUTH0_DOMAIN']!.isEmpty)) {
      _logger.shout(
          'Please set key NATIVE_AUTH0_DOMAIN in project .env file, for details '
          'see https://auth0.com/docs/quickstart/native/flutter/interactive');
      throw 'Please set key NATIVE_AUTH0_DOMAIN in project .env file';
    }
    if (!kIsWeb &&
        (!dotenv.env.containsKey('NATIVE_AUTH0_CLIENTID') ||
            dotenv.env['NATIVE_AUTH0_CLIENTID']!.isEmpty)) {
      _logger.shout(
          'Please set key NATIVE_AUTH0_CLIENTID in project .env file, for details '
          'see https://auth0.com/docs/quickstart/native/flutter/interactive');
      throw 'Please set key NATIVE_AUTH0_CLIENTID in project .env file';
    }

    if (kIsWeb) {
      _logger.info(
        'Initialize auth0 with domain ${dotenv.env['WEB_AUTH0_DOMAIN']}'
        ' and client ${dotenv.env['WEB_AUTH0_CLIENTID']}',
      );
      final auth0 = Auth0Web(
        dotenv.env['WEB_AUTH0_DOMAIN']!,
        dotenv.env['WEB_AUTH0_CLIENTID']!,
      );
      return auth0.onLoad();
    } else {
      _logger.info(
        'Initialize auth0 with domain ${dotenv.env['NATIVE_AUTH0_DOMAIN']}',
      );
      // final auth0 = Auth0(
      //   dotenv.env['NATIVE_AUTH0_DOMAIN']!,
      //   dotenv.env['NATIVE_AUTH0_CLIENTID']!,
      // );
      return null;
    }
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
        await auth0.loginWithRedirect(
          redirectUrl: dotenv.env['WEB_AUTH0_REDIRECT_URL'],
        );
      } on Exception catch (error) {
        state = const AsyncData(null);
        if (!error.toString().contains('POPUP_CLOSED')) {
          rethrow;
        }
      }
    } else {
      final auth0 = Auth0(
        dotenv.env['NATIVE_AUTH0_DOMAIN']!,
        dotenv.env['NATIVE_AUTH0_CLIENTID']!,
      );
      state = const AsyncLoading();
      try {
        state = AsyncData(
          await auth0.webAuthentication().login(
              // redirectUrl: dotenv.env['NATIVE_AUTH0_REDIRECT_URL'],
              ),
        );
      } on Exception catch (error) {
        state = const AsyncData(null);
        if (!error.toString().contains('authentication_canceled')) {
          rethrow;
        }
      }
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
      final auth0 = Auth0(
        dotenv.env['NATIVE_AUTH0_DOMAIN']!,
        dotenv.env['NATIVE_AUTH0_DOMAIN']!,
      );
      state = const AsyncLoading();
      await auth0.webAuthentication().logout();
      state = const AsyncData(null);
    }
  }
}
