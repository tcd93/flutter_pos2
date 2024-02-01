import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/login/login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

final _logger = Logger('Drawer Header');

class DrawerHeaderItem extends ConsumerWidget {
  const DrawerHeaderItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cred = ref.watch(loginProvider).value;

    if (cred == null) return const CircleAvatar();
    _logger.info(cred.user.pictureUrl.toString());
    return CircleAvatar(
      backgroundImage: cred.user.pictureUrl != null
          ? NetworkImage(cred.user.pictureUrl.toString())
          : null,
      child: Align(
        alignment: Alignment.bottomRight,
        child: Text(
          'Hello ${cred.user.nickname}!',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}
