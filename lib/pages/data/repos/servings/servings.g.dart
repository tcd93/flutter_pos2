// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'servings.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$portionHash() => r'cb9456948fcaa81919b31d6fa50577b52148f8f2';

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

abstract class _$Portion extends BuildlessAutoDisposeAsyncNotifier<int?> {
  late final int cardID;
  late final int dishID;

  FutureOr<int?> build(
    int cardID,
    int dishID,
  );
}

/// See also [Portion].
@ProviderFor(Portion)
const portionProvider = PortionFamily();

/// See also [Portion].
class PortionFamily extends Family<AsyncValue<int?>> {
  /// See also [Portion].
  const PortionFamily();

  /// See also [Portion].
  PortionProvider call(
    int cardID,
    int dishID,
  ) {
    return PortionProvider(
      cardID,
      dishID,
    );
  }

  @override
  PortionProvider getProviderOverride(
    covariant PortionProvider provider,
  ) {
    return call(
      provider.cardID,
      provider.dishID,
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
  String? get name => r'portionProvider';
}

/// See also [Portion].
class PortionProvider
    extends AutoDisposeAsyncNotifierProviderImpl<Portion, int?> {
  /// See also [Portion].
  PortionProvider(
    int cardID,
    int dishID,
  ) : this._internal(
          () => Portion()
            ..cardID = cardID
            ..dishID = dishID,
          from: portionProvider,
          name: r'portionProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$portionHash,
          dependencies: PortionFamily._dependencies,
          allTransitiveDependencies: PortionFamily._allTransitiveDependencies,
          cardID: cardID,
          dishID: dishID,
        );

  PortionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.cardID,
    required this.dishID,
  }) : super.internal();

  final int cardID;
  final int dishID;

  @override
  FutureOr<int?> runNotifierBuild(
    covariant Portion notifier,
  ) {
    return notifier.build(
      cardID,
      dishID,
    );
  }

  @override
  Override overrideWith(Portion Function() create) {
    return ProviderOverride(
      origin: this,
      override: PortionProvider._internal(
        () => create()
          ..cardID = cardID
          ..dishID = dishID,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        cardID: cardID,
        dishID: dishID,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<Portion, int?> createElement() {
    return _PortionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PortionProvider &&
        other.cardID == cardID &&
        other.dishID == dishID;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, cardID.hashCode);
    hash = _SystemHash.combine(hash, dishID.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PortionRef on AutoDisposeAsyncNotifierProviderRef<int?> {
  /// The parameter `cardID` of this provider.
  int get cardID;

  /// The parameter `dishID` of this provider.
  int get dishID;
}

class _PortionProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<Portion, int?>
    with PortionRef {
  _PortionProviderElement(super.provider);

  @override
  int get cardID => (origin as PortionProvider).cardID;
  @override
  int get dishID => (origin as PortionProvider).dishID;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
