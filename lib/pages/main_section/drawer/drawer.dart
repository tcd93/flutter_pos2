import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/login/login.dart';
import 'package:flutter_pos/pages/main_section/drawer/default_discount_rate/default_discount_rate.dart';
import 'package:flutter_pos/pages/main_section/drawer/drawer_header.dart';
import 'package:flutter_pos/pages/main_section/drawer/edit_menu/edit_menu_item.dart';
import 'package:flutter_pos/pages/main_section/drawer/local_area_network/network_item.dart';
import 'package:flutter_pos/pages/main_section/drawer/reports/report_item.dart';
import 'package:flutter_pos/utils/ui_helpers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'login/login_item.dart';

class PageDrawer extends ConsumerWidget {
  const PageDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cred = ref.watch(loginProvider).unwrapPrevious().valueOrNull;

    return Theme(
      data: Theme.of(context).copyWith(
        listTileTheme: const ListTileThemeData(
          style: ListTileStyle.drawer,
        ),
      ),
      child: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              key: ValueKey(100),
              child: DrawerHeaderItem(),
            ),
            const _SwitchTheme(key: ValueKey(1)),
            const Divider(),
            const DefaultDiscountRate(),
            const Divider(),
            const LoginItem(key: ValueKey(2)),
            const Divider(),
            if (cred != null) ...[
              const ReportItem(key: ValueKey(3)),
              const Divider(),
              const NetworkItem(key: ValueKey(4)),
              const Divider(),
              const EditMenuItem(),
            ],
          ],
        ),
      ),
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
