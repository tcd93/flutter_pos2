import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/login/login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginItem extends ConsumerWidget {
  const LoginItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cred = ref.watch(loginProvider).value;
    return ListTile(
      title: cred != null ? const Text('Logout') : const Text('Login'),
      leading:
          cred != null ? const Icon(Icons.logout) : const Icon(Icons.login),
      onTap: () async {
        if (cred != null) {
          await ref.read(loginProvider.notifier).logout();
          return;
        }
        // for web, open navigate to url login page
        if (kIsWeb) {
          await ref.read(loginProvider.notifier).login();
          return;
        }
        Navigator.pushNamed(context, '/login');
      },
    );
  }
}
