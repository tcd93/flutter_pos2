import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login.g.dart';

@Riverpod(keepAlive: true)
class Login extends _$Login {
  @override
  bool build() => false;

  void login() => state = true;

  void logout() => state = false;
}
