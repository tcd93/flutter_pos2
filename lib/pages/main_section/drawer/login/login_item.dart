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
        // for web demo, show sample login and password so visitor can login
        // then, open navigate to url login page
        if (kIsWeb) {
          final ok = await showAdaptiveDialog(
            context: context,
            builder: (context) {
              return AlertDialog.adaptive(
                // color primary
                icon: const Icon(Icons.info_outline),
                title: const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Please configure project ',
                      ),
                      TextSpan(
                        text: '.env',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: ' file to use your own login credentials, see ',
                      ),
                      TextSpan(
                        text: '.env.example',
                        // italic
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      TextSpan(
                        text: ' file at project root.',
                      )
                    ],
                  ),
                  textAlign: TextAlign.left,
                ),
                content: SelectableRegion(
                  focusNode: FocusNode(),
                  selectionControls: MaterialTextSelectionControls(),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text('Sample Username:  '),
                          Expanded(child: Text('admin')),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Sample Password:  '),
                          Expanded(child: Text('admin')),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: const Text('OK'),
                  )
                ],
              );
            },
          );
          if (ok) await ref.read(loginProvider.notifier).login();
          return;
        }
        Navigator.pushNamed(context, '/login');
      },
    );
  }
}
