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
String _$labelHash() => r'9c7ad5b32e58c68c365726a84f183b1f58af1a93';

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
String _$resultNotifierHash() => r'ded3a4f29282663bfa84bb5def7a21748a48007f';

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

abstract class _$ResultNotifier extends BuildlessAutoDisposeNotifier<int> {
  late final int count;

  int build(
    int count,
  );
}

/// See also [ResultNotifier].
@ProviderFor(ResultNotifier)
const resultNotifierProvider = ResultNotifierFamily();

/// See also [ResultNotifier].
class ResultNotifierFamily extends Family<int> {
  /// See also [ResultNotifier].
  const ResultNotifierFamily();

  /// See also [ResultNotifier].
  ResultNotifierProvider call(
    int count,
  ) {
    return ResultNotifierProvider(
      count,
    );
  }

  @override
  ResultNotifierProvider getProviderOverride(
    covariant ResultNotifierProvider provider,
  ) {
    return call(
      provider.count,
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
  String? get name => r'resultNotifierProvider';
}

/// See also [ResultNotifier].
class ResultNotifierProvider
    extends AutoDisposeNotifierProviderImpl<ResultNotifier, int> {
  /// See also [ResultNotifier].
  ResultNotifierProvider(
    int count,
  ) : this._internal(
          () => ResultNotifier()..count = count,
          from: resultNotifierProvider,
          name: r'resultNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$resultNotifierHash,
          dependencies: ResultNotifierFamily._dependencies,
          allTransitiveDependencies:
              ResultNotifierFamily._allTransitiveDependencies,
          count: count,
        );

  ResultNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.count,
  }) : super.internal();

  final int count;

  @override
  int runNotifierBuild(
    covariant ResultNotifier notifier,
  ) {
    return notifier.build(
      count,
    );
  }

  @override
  Override overrideWith(ResultNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: ResultNotifierProvider._internal(
        () => create()..count = count,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        count: count,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<ResultNotifier, int> createElement() {
    return _ResultNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ResultNotifierProvider && other.count == count;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, count.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ResultNotifierRef on AutoDisposeNotifierProviderRef<int> {
  /// The parameter `count` of this provider.
  int get count;
}

class _ResultNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<ResultNotifier, int>
    with ResultNotifierRef {
  _ResultNotifierProviderElement(super.provider);

  @override
  int get count => (origin as ResultNotifierProvider).count;
}

String _$serviceHash() => r'417b2c0ade432573ad794eee7075b9bffa07cff8';

/// See also [Service].
@ProviderFor(Service)
final serviceProvider = NotifierProvider<Service, WebRtcManager>.internal(
  Service.new,
  name: r'serviceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$serviceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Service = Notifier<WebRtcManager>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
