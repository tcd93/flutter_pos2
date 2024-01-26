import 'dart:async';

import 'package:bonsoir/bonsoir.dart';
import 'package:logging/logging.dart';

class Bonjour {
  static const String _type = '_stun._tcp';

  final _logger = Logger('Bonjour');
  Function(ResolvedBonsoirService service)? onDiscovery;
  Set<ResolvedBonsoirService> discoveredServices = {};

  BonsoirBroadcast? _broadcast;
  BonsoirDiscovery? _discovery;

  Bonjour({this.onDiscovery});

  Future<void> broadcast() async {
    final service = BonsoirService(
      name: 'Poor man\'s STUN',
      // Put your service type here. Syntax : _ServiceType._TransportProtocolName.
      //(see http://wiki.ros.org/zeroconf/Tutorials/Understanding%20Zeroconf%20Service%20Types).
      type: '_stun._tcp',
      port: 3030, // Put your service port here.
    );
    _broadcast = BonsoirBroadcast(service: service, printLogs: true);
    await _broadcast!.ready;
    await _broadcast!.start();
  }

  /// Discover services on network and add to [discoveredServices]
  Future<void> discover() async {
    _discovery = BonsoirDiscovery(type: _type, printLogs: true);
    await _discovery!.ready;
    _discovery!.eventStream!.listen(
      (event) {
        if (event.type == BonsoirDiscoveryEventType.discoveryServiceFound) {
          event.service!.resolve(_discovery!.serviceResolver);
        }
        if (event.type == BonsoirDiscoveryEventType.discoveryServiceResolved) {
          discoveredServices.add(event.service as ResolvedBonsoirService);
          onDiscovery?.call(event.service as ResolvedBonsoirService);
        }
        if (event.type == BonsoirDiscoveryEventType.discoveryServiceLost) {
          discoveredServices.remove(event.service);
        }
      },
      onError: (err, stack) {
        _logger.warning(err);
      },
    );
    await _discovery!.start();
  }

  Future<void> stopBroadcast() async {
    await _broadcast?.ready;
    await _broadcast?.stop();
  }

  Future<void> stopDiscovery() async {
    await _discovery?.stop();
  }
}
