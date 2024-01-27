// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dbHash() => r'700a49da1cf6bc5d49c787d784c1d46804363a7c';

/// See also [db].
@ProviderFor(db)
final dbProvider = Provider<DriftDB>.internal(
  db,
  name: r'dbProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$dbHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef DbRef = ProviderRef<DriftDB>;
String _$priceHash() => r'f9b13e87e0e9e29bc6cf6f6ca612b4205d7ad524';

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

/// See also [price].
@ProviderFor(price)
const priceProvider = PriceFamily();

/// See also [price].
class PriceFamily extends Family<AsyncValue<double?>> {
  /// See also [price].
  const PriceFamily();

  /// See also [price].
  PriceProvider call(
    int cardID,
  ) {
    return PriceProvider(
      cardID,
    );
  }

  @override
  PriceProvider getProviderOverride(
    covariant PriceProvider provider,
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
  String? get name => r'priceProvider';
}

/// See also [price].
class PriceProvider extends AutoDisposeFutureProvider<double?> {
  /// See also [price].
  PriceProvider(
    int cardID,
  ) : this._internal(
          (ref) => price(
            ref as PriceRef,
            cardID,
          ),
          from: priceProvider,
          name: r'priceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$priceHash,
          dependencies: PriceFamily._dependencies,
          allTransitiveDependencies: PriceFamily._allTransitiveDependencies,
          cardID: cardID,
        );

  PriceProvider._internal(
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
  Override overrideWith(
    FutureOr<double?> Function(PriceRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PriceProvider._internal(
        (ref) => create(ref as PriceRef),
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
  AutoDisposeFutureProviderElement<double?> createElement() {
    return _PriceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PriceProvider && other.cardID == cardID;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, cardID.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PriceRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `cardID` of this provider.
  int get cardID;
}

class _PriceProviderElement extends AutoDisposeFutureProviderElement<double?>
    with PriceRef {
  _PriceProviderElement(super.provider);

  @override
  int get cardID => (origin as PriceProvider).cardID;
}

String _$priceByDateHash() => r'48467377b73d05f51441fd1841eb11e4afd99710';

/// See also [priceByDate].
@ProviderFor(priceByDate)
const priceByDateProvider = PriceByDateFamily();

/// See also [priceByDate].
class PriceByDateFamily
    extends Family<AsyncValue<List<({DateTime dateTime, double? price})>>> {
  /// See also [priceByDate].
  const PriceByDateFamily();

  /// See also [priceByDate].
  PriceByDateProvider call(
    DateTimeRange range,
  ) {
    return PriceByDateProvider(
      range,
    );
  }

  @override
  PriceByDateProvider getProviderOverride(
    covariant PriceByDateProvider provider,
  ) {
    return call(
      provider.range,
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
  String? get name => r'priceByDateProvider';
}

/// See also [priceByDate].
class PriceByDateProvider extends AutoDisposeFutureProvider<
    List<({DateTime dateTime, double? price})>> {
  /// See also [priceByDate].
  PriceByDateProvider(
    DateTimeRange range,
  ) : this._internal(
          (ref) => priceByDate(
            ref as PriceByDateRef,
            range,
          ),
          from: priceByDateProvider,
          name: r'priceByDateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$priceByDateHash,
          dependencies: PriceByDateFamily._dependencies,
          allTransitiveDependencies:
              PriceByDateFamily._allTransitiveDependencies,
          range: range,
        );

  PriceByDateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.range,
  }) : super.internal();

  final DateTimeRange range;

  @override
  Override overrideWith(
    FutureOr<List<({DateTime dateTime, double? price})>> Function(
            PriceByDateRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PriceByDateProvider._internal(
        (ref) => create(ref as PriceByDateRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        range: range,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<({DateTime dateTime, double? price})>>
      createElement() {
    return _PriceByDateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PriceByDateProvider && other.range == range;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, range.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PriceByDateRef on AutoDisposeFutureProviderRef<
    List<({DateTime dateTime, double? price})>> {
  /// The parameter `range` of this provider.
  DateTimeRange get range;
}

class _PriceByDateProviderElement extends AutoDisposeFutureProviderElement<
    List<({DateTime dateTime, double? price})>> with PriceByDateRef {
  _PriceByDateProviderElement(super.provider);

  @override
  DateTimeRange get range => (origin as PriceByDateProvider).range;
}

String _$loginHash() => r'28223e4aec560ae13d2518320c9917a5f2d1812a';

/// See also [Login].
@ProviderFor(Login)
final loginProvider = NotifierProvider<Login, bool>.internal(
  Login.new,
  name: r'loginProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$loginHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Login = Notifier<bool>;
String _$pageStatusHash() => r'02c116666a15d8e0866f881be0ac4865f64d7391';

/// See also [PageStatus].
@ProviderFor(PageStatus)
final pageStatusProvider = NotifierProvider<PageStatus, Status>.internal(
  PageStatus.new,
  name: r'pageStatusProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$pageStatusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PageStatus = Notifier<Status>;
String _$selectedCardHash() => r'b2da156d01e6e67a191b973b7ca5118a8aff0cb3';

/// Current opened card in menu page
///
/// Copied from [SelectedCard].
@ProviderFor(SelectedCard)
final selectedCardProvider = NotifierProvider<SelectedCard, int?>.internal(
  SelectedCard.new,
  name: r'selectedCardProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$selectedCardHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedCard = Notifier<int?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
