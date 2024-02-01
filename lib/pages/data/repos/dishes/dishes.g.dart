// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dishes.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dishIDHash() => r'23e03053d170972cfffbe00a190fb6ecf576366e';

/// See also [DishID].
@ProviderFor(DishID)
final dishIDProvider =
    AutoDisposeAsyncNotifierProvider<DishID, List<int>>.internal(
  DishID.new,
  name: r'dishIDProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$dishIDHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DishID = AutoDisposeAsyncNotifier<List<int>>;
String _$dishItemHash() => r'444edb193d3842cb58b12689278187a4f057e09e';

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

abstract class _$DishItem extends BuildlessAsyncNotifier<Dish> {
  late final int dishID;

  FutureOr<Dish> build(
    int dishID,
  );
}

/// See also [DishItem].
@ProviderFor(DishItem)
const dishItemProvider = DishItemFamily();

/// See also [DishItem].
class DishItemFamily extends Family<AsyncValue<Dish>> {
  /// See also [DishItem].
  const DishItemFamily();

  /// See also [DishItem].
  DishItemProvider call(
    int dishID,
  ) {
    return DishItemProvider(
      dishID,
    );
  }

  @override
  DishItemProvider getProviderOverride(
    covariant DishItemProvider provider,
  ) {
    return call(
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
  String? get name => r'dishItemProvider';
}

/// See also [DishItem].
class DishItemProvider extends AsyncNotifierProviderImpl<DishItem, Dish> {
  /// See also [DishItem].
  DishItemProvider(
    int dishID,
  ) : this._internal(
          () => DishItem()..dishID = dishID,
          from: dishItemProvider,
          name: r'dishItemProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$dishItemHash,
          dependencies: DishItemFamily._dependencies,
          allTransitiveDependencies: DishItemFamily._allTransitiveDependencies,
          dishID: dishID,
        );

  DishItemProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.dishID,
  }) : super.internal();

  final int dishID;

  @override
  FutureOr<Dish> runNotifierBuild(
    covariant DishItem notifier,
  ) {
    return notifier.build(
      dishID,
    );
  }

  @override
  Override overrideWith(DishItem Function() create) {
    return ProviderOverride(
      origin: this,
      override: DishItemProvider._internal(
        () => create()..dishID = dishID,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        dishID: dishID,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<DishItem, Dish> createElement() {
    return _DishItemProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DishItemProvider && other.dishID == dishID;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, dishID.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DishItemRef on AsyncNotifierProviderRef<Dish> {
  /// The parameter `dishID` of this provider.
  int get dishID;
}

class _DishItemProviderElement
    extends AsyncNotifierProviderElement<DishItem, Dish> with DishItemRef {
  _DishItemProviderElement(super.provider);

  @override
  int get dishID => (origin as DishItemProvider).dishID;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
