import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pos/pages/data/ephemeral.dart';
import 'package:flutter_pos/pages/data/repos/servings_note/servings_note.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuBottomSheet extends ConsumerStatefulWidget {
  final Widget checkOutButton;

  const MenuBottomSheet({required this.checkOutButton, super.key});

  @override
  ConsumerState<MenuBottomSheet> createState() => _MenuBottomSheetState();
}

class _MenuBottomSheetState extends ConsumerState<MenuBottomSheet> {
  final noteController = TextEditingController();

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  Widget noteField(int cardID) {
    return TextField(
      controller: noteController,
      onChanged: (value) {
        ref.read(noteProvider(cardID).notifier).takeNote(value);
      },
      decoration: const InputDecoration(
        labelText: 'Note',
        counterText: '',
      ),
      maxLength: 80,
      minLines: 1,
      maxLines: 3,
      inputFormatters: [disallowNewLines],
      scrollPhysics: const NeverScrollableScrollPhysics(),
    );
  }

  final disallowNewLines = TextInputFormatter.withFunction(
    (oldValue, newValue) {
      if (newValue.text.contains('\n')) {
        return oldValue;
      } else {
        return newValue;
      }
    },
  );

  @override
  Widget build(BuildContext context) {
    final cardID = ref.watch(selectedCardProvider);
    if (cardID == null) {
      return const SizedBox();
    }
    final note = ref.read(noteProvider(cardID)).value ?? '';
    noteController.text = note;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: noteField(cardID),
          ),
          const SizedBox(width: 8.0),
          widget.checkOutButton,
        ],
      ),
    );
  }
}
