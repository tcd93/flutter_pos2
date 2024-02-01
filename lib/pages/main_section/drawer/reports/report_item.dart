import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportItem extends ConsumerWidget {
  const ReportItem({super.key});

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
