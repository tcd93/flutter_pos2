import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login.g.dart';

// For why we need empty dependencies,it's to suppress lint error.
// under-developed docs and bad support for auto-generated providers, see:
// https://github.com/rrousselGit/riverpod/tree/master/packages/riverpod_lint#scoped_providers_should_specify_dependencies-generator-only
@Riverpod(dependencies: [])

/// Provider for Login status and credentials, implemented by [LoginMobile] and
/// [LoginWeb], see route creation for path '/login' (should be in main.dart)
/// for Override details
class Login extends _$Login {
  @override
  Future<Credentials?> build() async {
    return null;
  }

  Future<bool> login({
    String? usernameOrEmail,
    String? password,
  }) {
    throw UnimplementedError('Check route /login for platform-specific '
        'LoginProvider overrides');
  }

  Future<bool> logout() {
    throw UnimplementedError('Check route /login for platform-specific '
        'LoginProvider overrides');
  }
}
