import 'package:flutter/material.dart';
import 'package:flutter_pos/mdns/bonjour.dart';

Future<(String, String)?> ipAddressDialog(BuildContext context) async {
  final bonjour = Bonjour();
  bonjour.discover();
  Iterable<String> hosts = [];

  final textController = TextEditingController();
  final passController = TextEditingController();
  final listenable = Listenable.merge([textController, passController]);

  final result = await showAdaptiveDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                constraints: BoxConstraints.tightFor(width: 600),
                labelText: 'IP address/name of host',
                hintText: '192.168.1.2',
              ),
              minLines: 1,
              maxLines: 1,
              scrollPhysics: const NeverScrollableScrollPhysics(),
              keyboardType: TextInputType.url,
            ),
            const Divider(),
            TextField(
              controller: passController,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                constraints: BoxConstraints.tightFor(width: 600),
                labelText: 'Passphrase',
              ),
              minLines: 1,
              maxLines: 1,
              maxLength: 12,
              scrollPhysics: const NeverScrollableScrollPhysics(),
              keyboardType: TextInputType.visiblePassword,
            ),
            const Divider(),
            StatefulBuilder(
              builder: (context, setState) {
                bonjour.onDiscovery = (service) {
                  setState(() {
                    hosts = bonjour.discoveredServices.map((s) => s.host ?? '');
                    textController.text = hosts.firstOrNull ?? '';
                  });
                };

                return DropdownButton<String>(
                  isExpanded: true,
                  value: hosts.firstOrNull,
                  items: hosts
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  hint: const Text(
                    'Searching for services hosting on local network...',
                    textScaler: TextScaler.linear(0.75),
                    textAlign: TextAlign.center,
                  ),
                  onChanged: hosts.isNotEmpty
                      ? (service) => textController.text = service ?? ''
                      : null,
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              bonjour.stopDiscovery();
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ListenableBuilder(
            listenable: listenable,
            builder: (context, _) {
              final show = textController.text.isNotEmpty &
                  passController.text.isNotEmpty;
              return TextButton(
                onPressed: show
                    ? () {
                        bonjour.stopDiscovery();
                        Navigator.pop(
                          context,
                          (textController.text, passController.text),
                        );
                      }
                    : null,
                child: const Text('OK'),
              );
            },
          ),
        ],
      );
    },
  );

  textController.dispose();
  passController.dispose();
  return result;
}
