// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$originalPriceHash() => r'884846cb645666b5c88e06092f5c8da0687baa3c';

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

/// Original price
///
/// Copied from [originalPrice].
@ProviderFor(originalPrice)
const originalPriceProvider = OriginalPriceFamily();

/// Original price
///
/// Copied from [originalPrice].
class OriginalPriceFamily extends Family<AsyncValue<double?>> {
  /// Original price
  ///
  /// Copied from [originalPrice].
  const OriginalPriceFamily();

  /// Original price
  ///
  /// Copied from [originalPrice].
  OriginalPriceProvider call(
    int cardID,
  ) {
    return OriginalPriceProvider(
      cardID,
    );
  }

  @override
  OriginalPriceProvider getProviderOverride(
    covariant OriginalPriceProvider provider,
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
  String? get name => r'originalPriceProvider';
}

/// Original price
///
/// Copied from [originalPrice].
class OriginalPriceProvider extends AutoDisposeFutureProvider<double?> {
  /// Original price
  ///
  /// Copied from [originalPrice].
  OriginalPriceProvider(
    int cardID,
  ) : this._internal(
          (ref) => originalPrice(
            ref as OriginalPriceRef,
            cardID,
          ),
          from: originalPriceProvider,
          name: r'originalPriceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$originalPriceHash,
          dependencies: OriginalPriceFamily._dependencies,
          allTransitiveDependencies:
              OriginalPriceFamily._allTransitiveDependencies,
          cardID: cardID,
        );

  OriginalPriceProvider._internal(
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
    FutureOr<double?> Function(OriginalPriceRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: OriginalPriceProvider._internal(
        (ref) => create(ref as OriginalPriceRef),
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
    return _OriginalPriceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OriginalPriceProvider && other.cardID == cardID;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, cardID.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin OriginalPriceRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `cardID` of this provider.
  int get cardID;
}

class _OriginalPriceProviderElement
    extends AutoDisposeFutureProviderElement<double?> with OriginalPriceRef {
  _OriginalPriceProviderElement(super.provider);

  @override
  int get cardID => (origin as OriginalPriceProvider).cardID;
}

String _$priceHash() => r'e3b8f19c730659e29d1ab9a57595c204c903d249';

/// Discounted price
///
/// Copied from [price].
@ProviderFor(price)
const priceProvider = PriceFamily();

/// Discounted price
///
/// Copied from [price].
class PriceFamily extends Family<AsyncValue<double?>> {
  /// Discounted price
  ///
  /// Copied from [price].
  const PriceFamily();

  /// Discounted price
  ///
  /// Copied from [price].
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

/// Discounted price
///
/// Copied from [price].
class PriceProvider extends AutoDisposeFutureProvider<double?> {
  /// Discounted price
  ///
  /// Copied from [price].
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

String _$priceByDateHash() => r'c1503b9fd69495133ee6427aac179c436678304c';

/// For report 1
///
/// Copied from [priceByDate].
@ProviderFor(priceByDate)
const priceByDateProvider = PriceByDateFamily();

/// For report 1
///
/// Copied from [priceByDate].
class PriceByDateFamily extends Family<AsyncValue<List<GetPriceByDateResult>>> {
  /// For report 1
  ///
  /// Copied from [priceByDate].
  const PriceByDateFamily();

  /// For report 1
  ///
  /// Copied from [priceByDate].
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

/// For report 1
///
/// Copied from [priceByDate].
class PriceByDateProvider
    extends AutoDisposeFutureProvider<List<GetPriceByDateResult>> {
  /// For report 1
  ///
  /// Copied from [priceByDate].
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
    FutureOr<List<GetPriceByDateResult>> Function(PriceByDateRef provider)
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
  AutoDisposeFutureProviderElement<List<GetPriceByDateResult>> createElement() {
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

mixin PriceByDateRef
    on AutoDisposeFutureProviderRef<List<GetPriceByDateResult>> {
  /// The parameter `range` of this provider.
  DateTimeRange get range;
}

class _PriceByDateProviderElement
    extends AutoDisposeFutureProviderElement<List<GetPriceByDateResult>>
    with PriceByDateRef {
  _PriceByDateProviderElement(super.provider);

  @override
  DateTimeRange get range => (origin as PriceByDateProvider).range;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
