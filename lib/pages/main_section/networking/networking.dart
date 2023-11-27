import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/webrtc.dart';
import 'package:flutter_pos/pages/main_section/networking/ip_search_dialog.dart';
import 'package:flutter_pos/pages/main_section/networking/sync_progress_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

Future<String?> askForPassphrase(BuildContext context) {
  return showAdaptiveDialog(
      context: context,
      builder: (context) {
        final textController = TextEditingController();
        return AlertDialog(
          content: TextFormField(
            controller: textController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              constraints: BoxConstraints.tightFor(width: 600),
              labelText: 'Passphrase',
            ),
            minLines: 1,
            maxLines: 1,
            maxLength: 12,
            keyboardType: TextInputType.number,
            scrollPhysics: NeverScrollableScrollPhysics(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, textController.text);
              },
              child: const Text('OK'),
            ),
          ],
        );
      });
}

@visibleForTesting
class Networking extends ConsumerWidget {
  const Networking({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _showSnackBarOnStateChanges(context, ref);

    return ExpansionTile(
      maintainState: true,
      title: Text('Local Area Network'),
      leading: Icon(Icons.lan),
      children: [
        Consumer(
          builder: (context, ref, icon) {
            final hosting = ref.watch(hostStatusProvider);

            return ListTile(
              title: hosting ? Text('Stop hosting') : Text('Create host'),
              leading: icon,
              onTap: () async {
                final signaler = ref.read(serviceProvider);
                if (!hosting) {
                  final pass = await askForPassphrase(context);
                  if (pass != null)
                    await signaler.startServer(passphrase: pass);
                } else {
                  await signaler.closeServer();
                }
              },
            );
          },
          child: Icon(Icons.computer),
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
                final ip = await ipAddressDialog(context);
                if (ip != null) {
                  try {
                    final label = 'channel-${_idGenerator()}';
                    final receiver = ref.read(serviceProvider);
                    // TODO: ask for passphrase in ipDialog
                    await receiver.createChannel(ip, label, '123123');
                  } catch (ex) {
                    _showSnackBar(context, ex.toString());
                    throw ex;
                  }
                }
              },
            );
          },
          child: Icon(Icons.sync),
        ),
        // disconnect button
        Consumer(
          builder: (context, ref, icon) {
            final state = ref.watch(peerConnectionStateProvider);
            final label = ref.watch(labelProvider);

            return ListTile(
              enabled: state ==
                      RTCPeerConnectionState.RTCPeerConnectionStateConnected &&
                  label != null,
              title: Text('Disconnect'),
              leading: icon,
              onTap: () async {
                // WebRTC events are not fired in the caller side
                // set states manually
                ref.read(peerConnectionStateProvider.notifier).set(
                      RTCPeerConnectionState.RTCPeerConnectionStateDisconnected,
                    );
                final service = ref.read(serviceProvider);
                service.disconnect();
              },
            );
          },
          child: Icon(Icons.sync_disabled),
        ),
        // broadcast transaction data for other devices to sync
        Consumer(
          builder: (context, ref, icon) {
            final state = ref.watch(peerConnectionStateProvider);
            final label = ref.watch(labelProvider);

            return ListTile(
              enabled: state ==
                      RTCPeerConnectionState.RTCPeerConnectionStateConnected &&
                  label != null,
              title: Text('Send transactions to other connected devices'),
              leading: icon,
              onTap: () => syncDialog(context, ref),
            );
          },
          child: Icon(Icons.sync_disabled),
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
    ));
  }

  void _showSnackBarOnStateChanges(BuildContext context, WidgetRef ref) {
    ref.listen(peerConnectionStateProvider, (prev, next) {
      switch (next) {
        case RTCPeerConnectionState.RTCPeerConnectionStateDisconnected:
          _showSnackBar(context, 'Disconnected');
        case RTCPeerConnectionState.RTCPeerConnectionStateConnected:
          _showSnackBar(context, 'Connected');
        default:
          return;
      }
    });
  }
}
