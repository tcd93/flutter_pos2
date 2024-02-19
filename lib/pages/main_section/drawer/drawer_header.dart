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
    _logger.info(cred.user.customClaims.toString());
    // used Auth0's login flow to add custom claim
    // this uses alternate pic url instead of default one
    final picUrl = cred.user.customClaims?['alt_picture'] ??
        cred.user.pictureUrl.toString();
    return CircleAvatar(
      backgroundImage: NetworkImage(picUrl),
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
