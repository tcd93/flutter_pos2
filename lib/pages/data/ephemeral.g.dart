// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ephemeral.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$discountRateHash() => r'2a540015bc30f13ea83a1fb02adf343f13b6f60a';

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

abstract class _$DiscountRate extends BuildlessAutoDisposeNotifier<double> {
  late final int cardID;

  double build(
    int cardID,
  );
}

/// discount = 1.0 => no discount
/// discount = 0.9 => 10% discount
///
/// Copied from [DiscountRate].
@ProviderFor(DiscountRate)
const discountRateProvider = DiscountRateFamily();

/// discount = 1.0 => no discount
/// discount = 0.9 => 10% discount
///
/// Copied from [DiscountRate].
class DiscountRateFamily extends Family<double> {
  /// discount = 1.0 => no discount
  /// discount = 0.9 => 10% discount
  ///
  /// Copied from [DiscountRate].
  const DiscountRateFamily();

  /// discount = 1.0 => no discount
  /// discount = 0.9 => 10% discount
  ///
  /// Copied from [DiscountRate].
  DiscountRateProvider call(
    int cardID,
  ) {
    return DiscountRateProvider(
      cardID,
    );
  }

  @override
  DiscountRateProvider getProviderOverride(
    covariant DiscountRateProvider provider,
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
  String? get name => r'discountRateProvider';
}

/// discount = 1.0 => no discount
/// discount = 0.9 => 10% discount
///
/// Copied from [DiscountRate].
class DiscountRateProvider
    extends AutoDisposeNotifierProviderImpl<DiscountRate, double> {
  /// discount = 1.0 => no discount
  /// discount = 0.9 => 10% discount
  ///
  /// Copied from [DiscountRate].
  DiscountRateProvider(
    int cardID,
  ) : this._internal(
          () => DiscountRate()..cardID = cardID,
          from: discountRateProvider,
          name: r'discountRateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$discountRateHash,
          dependencies: DiscountRateFamily._dependencies,
          allTransitiveDependencies:
              DiscountRateFamily._allTransitiveDependencies,
          cardID: cardID,
        );

  DiscountRateProvider._internal(
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
  double runNotifierBuild(
    covariant DiscountRate notifier,
  ) {
    return notifier.build(
      cardID,
    );
  }

  @override
  Override overrideWith(DiscountRate Function() create) {
    return ProviderOverride(
      origin: this,
      override: DiscountRateProvider._internal(
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
  AutoDisposeNotifierProviderElement<DiscountRate, double> createElement() {
    return _DiscountRateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DiscountRateProvider && other.cardID == cardID;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, cardID.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DiscountRateRef on AutoDisposeNotifierProviderRef<double> {
  /// The parameter `cardID` of this provider.
  int get cardID;
}

class _DiscountRateProviderElement
    extends AutoDisposeNotifierProviderElement<DiscountRate, double>
    with DiscountRateRef {
  _DiscountRateProviderElement(super.provider);

  @override
  int get cardID => (origin as DiscountRateProvider).cardID;
}

String _$bottomSheetStatusHash() => r'3f06f67d40299a2388f50d664ba31dfabcd0399e';

/// See also [BottomSheetStatus].
@ProviderFor(BottomSheetStatus)
final bottomSheetStatusProvider =
    NotifierProvider<BottomSheetStatus, bool>.internal(
  BottomSheetStatus.new,
  name: r'bottomSheetStatusProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$bottomSheetStatusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BottomSheetStatus = Notifier<bool>;
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
String _$edittingDishIDHash() => r'0e55968cb6ceb6aa3313168edf661dfbb48133d9';

/// See also [EdittingDishID].
@ProviderFor(EdittingDishID)
final edittingDishIDProvider = NotifierProvider<EdittingDishID, int?>.internal(
  EdittingDishID.new,
  name: r'edittingDishIDProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$edittingDishIDHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$EdittingDishID = Notifier<int?>;
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
