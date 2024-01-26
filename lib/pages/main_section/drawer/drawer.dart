import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/db.dart';
import 'package:flutter_pos/pages/main_section/drawer/local_area_network/networking.dart';
import 'package:flutter_pos/utils/ui_helpers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PageDrawer extends StatelessWidget {
  const PageDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        listTileTheme: const ListTileThemeData(
          style: ListTileStyle.drawer,
        ),
      ),
      child: Drawer(
        child: ListView(
          children: const [
            _SwitchTheme(key: ValueKey(1)),
            Divider(),
            _LogInOut(key: ValueKey(2)),
            Divider(),
            _Reporting(key: ValueKey(3)),
            Divider(),
            Networking(key: ValueKey(4)),
          ],
        ),
      ),
    );
  }
}

class _LogInOut extends ConsumerWidget {
  const _LogInOut({super.key});

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

class _Reporting extends ConsumerWidget {
  const _Reporting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ExpansionTile(
      title: const Text('Report'),
      leading: const Icon(Icons.analytics),
      children: [
        ListTile(
          title: const Text('Report 1'),
          hoverColor: Theme.of(context).highlightColor,
          onTap: () {
            Navigator.of(context).pushNamed('/report');
          },
        ),
        ListTile(
          title: const Text('Report 2'),
          hoverColor: Theme.of(context).highlightColor,
          onTap: () {},
        )
      ],
    );
  }
}

class _SwitchTheme extends StatelessWidget {
  const _SwitchTheme({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Switch Theme'),
      leading: const Icon(Icons.light_mode),
      onTap: () => EasyDynamicTheme.of(context).changeTheme(
        dark: !isThemeCurrentlyDark(context),
      ),
    );
  }
}
