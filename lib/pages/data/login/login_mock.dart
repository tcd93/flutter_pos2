import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter_pos/pages/data/login/login.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_mock.g.dart';

final _logger = Logger('Login');

@riverpod
class LoginMock extends _$LoginMock implements Login {
  @override
  Future<Credentials?> build() async {
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

    if (usernameOrEmail == 'admin' && password == 'admin') {
      state = AsyncData(
        Credentials(
          accessToken: 'mock',
          idToken: 'mock',
          tokenType: 'mock',
          expiresAt: DateTime.now().add(const Duration(days: 1)),
          user: UserProfile(
            name: 'admin',
            nickname: 'admin',
            email: 'admin',
            sub: 'admin',
            pictureUrl: Uri.parse(
              'https://cdn-icons-png.flaticon.com/128/3171/3171065.png',
            ),
          ),
        ),
      );
      return true;
    } else {
      state = AsyncError('Invalid name/email or password', StackTrace.current);
      Future.delayed(const Duration(seconds: 5), _clearErrors);
    }
    return false;
  }

  @override
  Future<bool> logout() async {
    state = const AsyncLoading();
    state = const AsyncData(null);
    return true;
  }
}
