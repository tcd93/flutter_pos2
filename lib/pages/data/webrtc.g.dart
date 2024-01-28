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
String _$labelHash() => r'30fefad2fea35026e942cdf9652497763a8be2ce';

/// See also [Label].
@ProviderFor(Label)
final labelProvider = NotifierProvider<Label, List<String?>>.internal(
  Label.new,
  name: r'labelProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$labelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Label = Notifier<List<String?>>;
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
String _$syncDoneNotifierHash() => r'2147b5e762d065b24bbcf3e56131f3d6df863124';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$SyncDoneNotifier extends BuildlessAutoDisposeNotifier<bool> {
  late final String channelLabel;

  bool build(
    String channelLabel,
  );
}

/// See also [SyncDoneNotifier].
@ProviderFor(SyncDoneNotifier)
const syncDoneNotifierProvider = SyncDoneNotifierFamily();

/// See also [SyncDoneNotifier].
class SyncDoneNotifierFamily extends Family<bool> {
  /// See also [SyncDoneNotifier].
  const SyncDoneNotifierFamily();

  /// See also [SyncDoneNotifier].
  SyncDoneNotifierProvider call(
    String channelLabel,
  ) {
    return SyncDoneNotifierProvider(
      channelLabel,
    );
  }

  @override
  SyncDoneNotifierProvider getProviderOverride(
    covariant SyncDoneNotifierProvider provider,
  ) {
    return call(
      provider.channelLabel,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'syncDoneNotifierProvider';
}

/// See also [SyncDoneNotifier].
class SyncDoneNotifierProvider
    extends AutoDisposeNotifierProviderImpl<SyncDoneNotifier, bool> {
  /// See also [SyncDoneNotifier].
  SyncDoneNotifierProvider(
    String channelLabel,
  ) : this._internal(
          () => SyncDoneNotifier()..channelLabel = channelLabel,
          from: syncDoneNotifierProvider,
          name: r'syncDoneNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$syncDoneNotifierHash,
          dependencies: SyncDoneNotifierFamily._dependencies,
          allTransitiveDependencies:
              SyncDoneNotifierFamily._allTransitiveDependencies,
          channelLabel: channelLabel,
        );

  SyncDoneNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.channelLabel,
  }) : super.internal();

  final String channelLabel;

  @override
  bool runNotifierBuild(
    covariant SyncDoneNotifier notifier,
  ) {
    return notifier.build(
      channelLabel,
    );
  }

  @override
  Override overrideWith(SyncDoneNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: SyncDoneNotifierProvider._internal(
        () => create()..channelLabel = channelLabel,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        channelLabel: channelLabel,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<SyncDoneNotifier, bool> createElement() {
    return _SyncDoneNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SyncDoneNotifierProvider &&
        other.channelLabel == channelLabel;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, channelLabel.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SyncDoneNotifierRef on AutoDisposeNotifierProviderRef<bool> {
  /// The parameter `channelLabel` of this provider.
  String get channelLabel;
}

class _SyncDoneNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<SyncDoneNotifier, bool>
    with SyncDoneNotifierRef {
  _SyncDoneNotifierProviderElement(super.provider);

  @override
  String get channelLabel => (origin as SyncDoneNotifierProvider).channelLabel;
}

String _$webRtcServiceHash() => r'daed772b7f8b85c4c9eb47478101855b8b0a3aa0';

/// See also [WebRtcService].
@ProviderFor(WebRtcService)
final webRtcServiceProvider =
    NotifierProvider<WebRtcService, WebRtcManager>.internal(
  WebRtcService.new,
  name: r'webRtcServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$webRtcServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$WebRtcService = Notifier<WebRtcManager>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
