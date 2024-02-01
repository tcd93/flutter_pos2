import 'package:flutter/material.dart';

class AskPassphraseDialog extends StatefulWidget {
  const AskPassphraseDialog({super.key});

  @override
  State<AskPassphraseDialog> createState() => _AskPassphraseDialogState();
}

class _AskPassphraseDialogState extends State<AskPassphraseDialog> {
  final passController = TextEditingController();

  @override
  void dispose() {
    passController.dispose();
    super.dispose();
  }

  void returnPassphrase() {
    Navigator.pop(context, passController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // account for keyboard height
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: ListTile(
        title: TextField(
          controller: passController,
          obscureText: true,
          autofocus: true,
          onEditingComplete: returnPassphrase,
          decoration: InputDecoration(
            labelText: 'Passphrase',
            counterText: '',
            suffix: ListenableBuilder(
              listenable: passController,
              builder: (context, _) {
                return Text(
                  '${passController.value.text.length.toString()}/12',
                );
              },
            ),
          ),
          minLines: 1,
          maxLines: 1,
          maxLength: 12,
          keyboardType: TextInputType.number,
          scrollPhysics: const NeverScrollableScrollPhysics(),
        ),
        // trailing: ListenableBuilder(
        //   listenable: passController,
        //   builder: (context, icon) {
        //     return TextButton(
        //       onPressed: passController.text.isNotEmpty
        //           ? () => returnPassphrase
        //           : null,
        //       child: icon!,
        //     );
        //   },
        //   child: const Icon(Icons.send),
        // ),
      ),
    );
  }
}
