import 'package:flutter/material.dart';

class EditMenuItem extends StatelessWidget {
  const EditMenuItem({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Edit Menu'),
      leading: const Icon(Icons.menu_book),
      onTap: () => Navigator.of(context).pushNamed('/edit-menu'),
    );
  }
}
