import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginItem extends ConsumerWidget {
  const LoginItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cred = ref.watch(loginProvider).unwrapPrevious().valueOrNull;
    final lctrl = ref.read(loginProvider.notifier);
    return ListTile(
      title: cred != null ? const Text('Logout') : const Text('Login'),
      leading:
          cred != null ? const Icon(Icons.logout) : const Icon(Icons.login),
      onTap: () async =>
          cred != null ? await lctrl.logout() : await lctrl.login(),
    );
  }
}
