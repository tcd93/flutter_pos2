import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/db.dart';
import 'package:flutter_pos/pages/data/webrtc.dart';
import 'package:flutter_pos/pages/main_section/drawer.dart';
import 'package:flutter_pos/pages/main_section/page_body.dart';
import 'package:flutter_pos/widgets/sexy_bottom_sheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

void _showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(text, overflow: TextOverflow.ellipsis),
  ));
}

void _showSnackBarOnDoneNotifier(BuildContext context, WidgetRef ref) {
  ref.watch(labelProvider).forEach((label) {
    if (label == null) return;
    ref.listen(syncDoneNotifierProvider(label), (prev, next) {
      if (next) {
        _showSnackBar(context, 'Synced with $label');
      }
    });
  });
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

class Pages extends ConsumerStatefulWidget {
  @override
  createState() => _PagesState();
}

class _PagesState extends ConsumerState<Pages> {
  final sheetIndexNotifier = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    _showSnackBarOnStateChanges(context, ref);
    _showSnackBarOnDoneNotifier(context, ref);

    final result = ref.watch(pageIDProvider);
    return result.when(
      data: (pageIDs) {
        return Scaffold(
          body: PageBody(pageIDs, sheetIndexNotifier),
          extendBody: true, // to achieve the bottom bar rounded corners effect
          endDrawer: const PageDrawer(),
          bottomNavigationBar: SexyBottomSheet(
            items: pageIDs.map((pageID) {
              final name = ref.watch(pageNameProvider(pageID)).value;
              return Text(name ?? '');
            }).toList(growable: false),
            imageBuilder: (_) => Image.asset(
              'assets/icon/icon-legacy.png',
              fit: BoxFit.cover,
            ),
            selectedIndex: sheetIndexNotifier,
          ),
        );
      },
      error: (error, stackTrace) => Center(child: Text(error.toString())),
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }

  @override
  void dispose() {
    sheetIndexNotifier.dispose();
    super.dispose();
  }
}
