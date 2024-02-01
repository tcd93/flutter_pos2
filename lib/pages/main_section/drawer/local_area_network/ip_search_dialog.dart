import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos/mdns/bonjour.dart';
import 'package:flutter_pos/pages/main_section/common/loading_bar.dart';
import 'package:flutter_pos/pages/main_section/drawer/local_area_network/connection_data.dart';
import 'package:logging/logging.dart';

final _logger = Logger('IP Search');

class IpAddressDialog extends StatefulWidget {
  const IpAddressDialog({super.key});

  @override
  State<IpAddressDialog> createState() => _IpAddressDialogState();
}

class _IpAddressDialogState extends State<IpAddressDialog> {
  late final Bonjour? bonjour;
  final ipController = TextEditingController();
  final passController = TextEditingController();
  late final listenable = Listenable.merge([ipController, passController]);
  Iterable<String> hosts = [];

  @override
  void initState() {
    if (kIsWeb) {
      _logger.info('Bonsoir: no support for web, input address manually');
      bonjour = null;
    } else {
      bonjour = Bonjour();
    }

    bonjour?.discover();
    bonjour?.onDiscovery = (service) {
      setState(() {
        hosts = bonjour?.discoveredServices.map((s) => s.host ?? '') ?? [];
        ipController.text = hosts.firstOrNull ?? '';
      });
    };
    super.initState();
  }

  @override
  void dispose() {
    bonjour?.stopDiscovery();
    ipController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: ipController,
              decoration: const InputDecoration(
                constraints: BoxConstraints.tightFor(width: 600),
                labelText: 'IP address/name of host',
                hintText: '192.168.1.2',
              ),
              minLines: 1,
              maxLines: 1,
              scrollPhysics: const NeverScrollableScrollPhysics(),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: passController,
              obscureText: true,
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
            const SizedBox(height: 8.0),
            if (!kIsWeb)
              DropdownButton<String>(
                isExpanded: true,
                alignment: Alignment.center,
                underline: hosts.firstOrNull == null
                    ? const LoadingBar(widthFactor: 1.0)
                    : Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color.fromARGB(53, 189, 189, 189),
                            ),
                          ),
                        ),
                      ),
                value: hosts.firstOrNull,
                items: hosts
                    .map(
                      (searchedHost) => DropdownMenuItem(
                        value: searchedHost,
                        alignment: Alignment.center,
                        child: Text(searchedHost),
                      ),
                    )
                    .toList(),
                hint: const Text(
                  'Searching on local network...',
                  textScaler: TextScaler.linear(0.75),
                ),
                onChanged: hosts.isNotEmpty
                    ? (service) => ipController.text = service ?? ''
                    : null,
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            bonjour?.stopDiscovery();
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        ListenableBuilder(
          listenable: listenable,
          builder: (context, _) {
            final show =
                ipController.text.isNotEmpty & passController.text.isNotEmpty;
            return TextButton(
              onPressed: show
                  ? () {
                      bonjour?.stopDiscovery();
                      Navigator.pop<ConnectionData>(
                        context,
                        ConnectionData(ipController.text, passController.text),
                      );
                    }
                  : null,
              child: const Text('OK'),
            );
          },
        ),
      ],
    );
  }
}
