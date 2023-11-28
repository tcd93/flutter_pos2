// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'webrtc.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$hostStatusHash() => r'e6208c3572caa8de1f4b2d236ed7e3a655c29077';

/// See also [HostStatus].
@ProviderFor(HostStatus)
final hostStatusProvider = NotifierProvider<HostStatus, bool>.internal(
  HostStatus.new,
  name: r'hostStatusProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$hostStatusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$HostStatus = Notifier<bool>;
String _$labelHash() => r'2f4dde966b037ddcbc376b9b5eee64a9e66fdaac';

/// See also [Label].
@ProviderFor(Label)
final labelProvider = NotifierProvider<Label, String?>.internal(
  Label.new,
  name: r'labelProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$labelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Label = Notifier<String?>;
String _$peerConnectionStateHash() =>
    r'52e2de4b5e2d8d34e52a9da5664cfd2d330a8575';

/// See also [PeerConnectionState].
@ProviderFor(PeerConnectionState)
final peerConnectionStateProvider =
    NotifierProvider<PeerConnectionState, RTCPeerConnectionState?>.internal(
  PeerConnectionState.new,
  name: r'peerConnectionStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$peerConnectionStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PeerConnectionState = Notifier<RTCPeerConnectionState?>;
String _$roleHash() => r'c497fe4ca3f49cf73e5c6eb479907d1d3627a939';

/// See also [Role].
@ProviderFor(Role)
final roleProvider = NotifierProvider<Role, Profile>.internal(
  Role.new,
  name: r'roleProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$roleHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Role = Notifier<Profile>;
String _$serviceHash() => r'007fe47f57c181669789c2a1f6d69156812d487e';

/// See also [Service].
@ProviderFor(Service)
final serviceProvider = NotifierProvider<Service, Channel?>.internal(
  Service.new,
  name: r'serviceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$serviceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Service = Notifier<Channel?>;
String _$receiverServiceHash() => r'3bd85c6fac2f91e98622b1d4474ca89dfc45382c';

/// See also [_ReceiverService].
@ProviderFor(_ReceiverService)
final _receiverServiceProvider =
    NotifierProvider<_ReceiverService, Receiver>.internal(
  _ReceiverService.new,
  name: r'_receiverServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$receiverServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ReceiverService = Notifier<Receiver>;
String _$signalServiceHash() => r'05fb291fe9c497ded37d4312d319e04fabbab8bd';

/// See also [_SignalService].
@ProviderFor(_SignalService)
final _signalServiceProvider =
    NotifierProvider<_SignalService, Signaler>.internal(
  _SignalService.new,
  name: r'_signalServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$signalServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SignalService = Notifier<Signaler>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
