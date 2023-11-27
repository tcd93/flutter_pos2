import 'package:flutter_pos/pages/data/db.dart';
import 'package:flutter_pos/pages/main_section/networking/networking.dart';
import 'package:flutter_pos/utils/ui_helpers.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PageDrawer extends StatelessWidget {
  const PageDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        listTileTheme: ListTileThemeData(
          style: ListTileStyle.drawer,
        ),
      ),
      child: Drawer(
        child: ListView(
          children: [
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
      title: loggedIn ? Text('Logout') : Text('Login'),
      leading: loggedIn ? Icon(Icons.logout) : Icon(Icons.login),
      onTap: () => loggedIn ? lctrl.logout() : lctrl.login(),
    );
  }
}

class _Reporting extends ConsumerWidget {
  const _Reporting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ExpansionTile(
      title: Text('Report'),
      leading: Icon(Icons.analytics),
      children: [
        ListTile(
          title: Text('Report 1'),
          hoverColor: Theme.of(context).highlightColor,
          onTap: () {
            Navigator.of(context).pushNamed('/report');
          },
        ),
        ListTile(
          title: Text('Report 2'),
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
      title: Text('Switch Theme'),
      leading: Icon(Icons.light_mode),
      onTap: () => EasyDynamicTheme.of(context).changeTheme(
        dark: !isThemeCurrentlyDark(context),
      ),
    );
  }
}
