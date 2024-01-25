import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/db.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CollapsibleCardDetails extends ConsumerWidget {
  final int cardID;

  final VoidCallback openContainer;
  final double price;
  const CollapsibleCardDetails({
    super.key,
    required this.cardID,
    required this.openContainer,
    required this.price,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final note = ref.watch(noteProvider(cardID)).value ?? '';
    return ListTile(
      title: Text(price.toString() + ' \$'),
      trailing: OutlinedButton.icon(
        onPressed: () {
          ref.read(selectedCardProvider.notifier).open(cardID);
          // Navigator.of(context).pushNamed('/menu');
          openContainer();
        },
        icon: Icon(Icons.menu_open_outlined),
        label: Text('Menu'),
      ),
      subtitle: note.isNotEmpty
          ? Text(note, maxLines: 2, overflow: TextOverflow.ellipsis)
          : null,
      isThreeLine: false,
    );
  }
}
