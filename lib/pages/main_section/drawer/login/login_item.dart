import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginItem extends ConsumerWidget {
  const LoginItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(loginProvider);
    final lctrl = ref.read(loginProvider.notifier);
    return asyncValue.when(
      data: (cred) {
        return ListTile(
          title: cred != null ? const Text('Logout') : const Text('Login'),
          leading:
              cred != null ? const Icon(Icons.logout) : const Icon(Icons.login),
          onTap: () async =>
              cred != null ? await lctrl.logout() : await lctrl.login(),
        );
      },
      error: (error, stackTrace) {
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          SnackBar(
            content: Text(
              error.toString(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
        return const ListTile(
          leading: Icon(Icons.error),
          title: Text('Error'),
        );
      },
      loading: () {
        return const ListTile(
          leading: Icon(Icons.login),
          title: Text('Waiting'),
        );
      },
    );
  }
}
