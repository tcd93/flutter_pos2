// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$menuControlHash() => r'885f52ce5d0412c6a07745bea40d3797aa30bb4c';

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

abstract class _$MenuControl extends BuildlessAutoDisposeNotifier<MenuControl> {
  late final int cardID;

  MenuControl build(
    int cardID,
  );
}

/// See also [MenuControl].
@ProviderFor(MenuControl)
const menuControlProvider = MenuControlFamily();

/// See also [MenuControl].
class MenuControlFamily extends Family<MenuControl> {
  /// See also [MenuControl].
  const MenuControlFamily();

  /// See also [MenuControl].
  MenuControlProvider call(
    int cardID,
  ) {
    return MenuControlProvider(
      cardID,
    );
  }

  @override
  MenuControlProvider getProviderOverride(
    covariant MenuControlProvider provider,
  ) {
    return call(
      provider.cardID,
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
  String? get name => r'menuControlProvider';
}

/// See also [MenuControl].
class MenuControlProvider
    extends AutoDisposeNotifierProviderImpl<MenuControl, MenuControl> {
  /// See also [MenuControl].
  MenuControlProvider(
    int cardID,
  ) : this._internal(
          () => MenuControl()..cardID = cardID,
          from: menuControlProvider,
          name: r'menuControlProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$menuControlHash,
          dependencies: MenuControlFamily._dependencies,
          allTransitiveDependencies:
              MenuControlFamily._allTransitiveDependencies,
          cardID: cardID,
        );

  MenuControlProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.cardID,
  }) : super.internal();

  final int cardID;

  @override
  MenuControl runNotifierBuild(
    covariant MenuControl notifier,
  ) {
    return notifier.build(
      cardID,
    );
  }

  @override
  Override overrideWith(MenuControl Function() create) {
    return ProviderOverride(
      origin: this,
      override: MenuControlProvider._internal(
        () => create()..cardID = cardID,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        cardID: cardID,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<MenuControl, MenuControl> createElement() {
    return _MenuControlProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MenuControlProvider && other.cardID == cardID;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, cardID.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MenuControlRef on AutoDisposeNotifierProviderRef<MenuControl> {
  /// The parameter `cardID` of this provider.
  int get cardID;
}

class _MenuControlProviderElement
    extends AutoDisposeNotifierProviderElement<MenuControl, MenuControl>
    with MenuControlRef {
  _MenuControlProviderElement(super.provider);

  @override
  int get cardID => (origin as MenuControlProvider).cardID;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
