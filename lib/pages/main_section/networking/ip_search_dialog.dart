import 'package:flutter/material.dart';
import 'package:flutter_pos/mdns/bonjour.dart';

Future<String?> ipAddressDialog(BuildContext context) {
  final bonjour = Bonjour();
  bonjour.discover();
  Iterable<String> hosts = [];

  return showAdaptiveDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      final textController = TextEditingController();
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: textController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                constraints: BoxConstraints.tightFor(width: 600),
                labelText: 'IP address/name of host',
                hintText: '192.168.1.2',
              ),
              minLines: 1,
              maxLines: 1,
              scrollPhysics: NeverScrollableScrollPhysics(),
            ),
            Divider(),
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
                  hint: Text(
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
          TextButton(
            onPressed: () {
              bonjour.stopDiscovery();
              Navigator.pop(context, textController.text);
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
