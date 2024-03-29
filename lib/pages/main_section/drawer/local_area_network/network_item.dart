import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos/p2p/syncer.dart';
import 'package:flutter_pos/pages/data/repos/db.dart';
import 'package:flutter_pos/pages/data/webrtc.dart';
import 'package:flutter_pos/pages/main_section/drawer/local_area_network/ask_passhrase_dialog.dart';
import 'package:flutter_pos/pages/main_section/drawer/local_area_network/connection_data.dart';
import 'package:flutter_pos/pages/main_section/drawer/local_area_network/ip_search_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:logging/logging.dart';

final _logger = Logger('Networking');

@visibleForTesting
class NetworkItem extends ConsumerWidget {
  const NetworkItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ExpansionTile(
      maintainState: true,
      title: const Text('Local Area Network'),
      leading: const Icon(Icons.lan),
      children: [
        if (kIsWeb)
          const ListTile(
            title: Text('Can\'t create host in Web'),
            leading: Icon(Icons.computer),
            enabled: false,
          ),

        if (!kIsWeb)
          Consumer(
            builder: (context, ref, icon) {
              final hosting = ref.watch(hostStatusProvider);

              return ListTile(
                title: hosting
                    ? const Text('Stop hosting')
                    : const Text('Create host'),
                leading: icon,
                onTap: () async {
                  final signaler = ref.read(webRtcServiceProvider);
                  if (!hosting) {
                    final pass = await showModalBottomSheet<String?>(
                      context: context,
                      builder: (context) {
                        return const AskPassphraseDialog();
                      },
                    );
                    if (pass != null)
                      await signaler.startServer(passphrase: pass);
                  } else {
                    await signaler.closeServer();
                  }
                },
              );
            },
            child: const Icon(Icons.computer),
          ),
        // connect button
        Consumer(
          builder: (context, ref, icon) {
            final hosting = ref.watch(hostStatusProvider);
            final state = ref.watch(peerConnectionStateProvider);
            final label = ref.watch(labelProvider);

            return ListTile(
              enabled: !hosting &&
                  state !=
                      RTCPeerConnectionState.RTCPeerConnectionStateConnected,
              title: Text(
                state == RTCPeerConnectionState.RTCPeerConnectionStateConnected
                    ? 'Linked to $label'
                    : 'Link to host',
              ),
              leading: icon,
              onTap: () async {
                var result = await showAdaptiveDialog<ConnectionData>(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    // init Bonsoir mDNS service in this dialog
                    return const IpAddressDialog();
                  },
                );
                if (result != null) {
                  final ip = result.ip;
                  final passphrase = result.pass;
                  try {
                    final label = 'channel-${_idGenerator()}';
                    final receiver = ref.read(webRtcServiceProvider);
                    await receiver.createChannel(ip, label, passphrase);
                  } catch (ex) {
                    if (!context.mounted) {
                      _logger.warning(
                        'BuildContext is dismounted, unable to show snackbar',
                      );
                      return;
                    }
                    _showSnackBar(context, ex.toString());
                    rethrow;
                  }
                }
              },
            );
          },
          child: const Icon(Icons.sync),
        ),
        // disconnect button
        Consumer(
          builder: (context, ref, icon) {
            final state = ref.watch(peerConnectionStateProvider);
            final labels = ref.watch(labelProvider);

            return ListTile(
              enabled: state ==
                      RTCPeerConnectionState.RTCPeerConnectionStateConnected &&
                  labels.isNotEmpty,
              title: const Text('Disconnect'),
              leading: icon,
              onTap: () async {
                // WebRTC events are not fired in the caller side
                // set states manually
                ref.read(peerConnectionStateProvider.notifier).set(
                      RTCPeerConnectionState.RTCPeerConnectionStateDisconnected,
                    );
                final service = ref.read(webRtcServiceProvider);
                service.disconnect();
              },
            );
          },
          child: const Icon(Icons.sync_disabled),
        ),
        // broadcast transaction data for other devices to sync
        Consumer(
          builder: (context, ref, icon) {
            final state = ref.watch(peerConnectionStateProvider);
            final labels = ref.watch(labelProvider);

            return ListTile(
              enabled: state ==
                      RTCPeerConnectionState.RTCPeerConnectionStateConnected &&
                  labels.isNotEmpty,
              title: const Text('Send transactions to other connected devices'),
              leading: icon,
              onTap: () async {
                final db = ref.read(dbProvider);
                final syncer = Syncer(db);
                await for (final message in syncer.parseRecords()) {
                  ref.read(webRtcServiceProvider).send(message);
                }
              },
            );
          },
          child: const Icon(Icons.send_and_archive),
        ),
      ],
    );
  }

  String _idGenerator() {
    final now = DateTime.now();
    return now.microsecondsSinceEpoch.toString();
  }

  void _showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text, overflow: TextOverflow.ellipsis),
      duration: const Duration(seconds: 8),
    ));
  }
}
