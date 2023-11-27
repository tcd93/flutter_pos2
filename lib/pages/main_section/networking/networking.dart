import 'package:flutter_pos/p2p/channel.dart';
import 'package:flutter_pos/pages/data/webrtc.dart' hide ConnectionState;
import 'package:flutter_pos/pages/main_section/networking/ip_search_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

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
            final signaler = ref.read(signalServiceProvider);
            final hosting = ref.watch(hostStatusProvider);

            return ListTile(
              title: hosting ? Text('Stop hosting') : Text('Create host'),
              leading: icon,
              onTap: () async {
                if (!hosting) {
                  ref.read(roleProvider.notifier).set(Profile.signaler);
                  await signaler.startServer();
                } else {
                  await signaler.closeServer();
                }
              },
            );
          },
          child: Icon(Icons.computer),
        ),
        Consumer(
          builder: (context, ref, icon) {
            final receiver = ref.read(receiverServiceProvider);
            final hosting = ref.watch(hostStatusProvider);
            final state = ref.watch(connectionStateProvider);
            final label = ref.watch(labelProvider);

            return ListTile(
              enabled:
                  !hosting && state != RTCDataChannelState.RTCDataChannelOpen,
              title: Text(
                state == RTCDataChannelState.RTCDataChannelOpen
                    ? 'Linked to $label'
                    : 'Link to host',
              ),
              leading: icon,
              onTap: () async {
                final ip = await ipAddressDialog(context);
                if (ip != null) {
                  ref.read(roleProvider.notifier).set(Profile.receiver);
                  try {
                    final label = 'channel-${_idGenerator()}';
                    ref.read(labelProvider.notifier).set(label);
                    await receiver.createChannel(ip, label);
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
        Consumer(
          builder: (context, ref, icon) {
            final state = ref.watch(connectionStateProvider);
            final receiver = ref.read(receiverServiceProvider);
            final signaler = ref.read(signalServiceProvider);

            return ListTile(
              enabled: state == RTCDataChannelState.RTCDataChannelOpen,
              title: Text('Disconnect'),
              leading: icon,
              onTap: () async {
                receiver.disconnect();
                signaler.disconnect();
                // for some reason event is not fired for the caller side
                // had to set manually
                ref
                    .read(connectionStateProvider.notifier)
                    .set(RTCDataChannelState.RTCDataChannelClosed);
                ref.read(labelProvider.notifier).set(null);
              },
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
    ref.listen(connectionStateProvider, (prev, next) {
      switch (next) {
        case RTCDataChannelState.RTCDataChannelClosed:
          _showSnackBar(context, 'Disconnected');
        case RTCDataChannelState.RTCDataChannelOpen:
          _showSnackBar(context, 'Connected');
        default:
          return;
      }
    });
  }
}
