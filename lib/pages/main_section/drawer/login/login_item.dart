import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginItem extends ConsumerWidget {
  const LoginItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loggedIn = ref.watch(loginProvider);
    final lctrl = ref.read(loginProvider.notifier);
    return ListTile(
      title: loggedIn ? const Text('Logout') : const Text('Login'),
      leading: loggedIn ? const Icon(Icons.logout) : const Icon(Icons.login),
      onTap: () => loggedIn ? lctrl.logout() : lctrl.login(),
    );
  }
}
