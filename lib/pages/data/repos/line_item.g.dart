// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'line_item.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$lineItemsHash() => r'07fcd2a73d77d1c7f5123511593433e994b1f152';

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

abstract class _$LineItems
    extends BuildlessAutoDisposeAsyncNotifier<List<LineItem>> {
  late final int cardID;

  FutureOr<List<LineItem>> build(
    int cardID,
  );
}

/// See also [LineItems].
@ProviderFor(LineItems)
const lineItemsProvider = LineItemsFamily();

/// See also [LineItems].
class LineItemsFamily extends Family<AsyncValue<List<LineItem>>> {
  /// See also [LineItems].
  const LineItemsFamily();

  /// See also [LineItems].
  LineItemsProvider call(
    int cardID,
  ) {
    return LineItemsProvider(
      cardID,
    );
  }

  @override
  LineItemsProvider getProviderOverride(
    covariant LineItemsProvider provider,
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
  String? get name => r'lineItemsProvider';
}

/// See also [LineItems].
class LineItemsProvider
    extends AutoDisposeAsyncNotifierProviderImpl<LineItems, List<LineItem>> {
  /// See also [LineItems].
  LineItemsProvider(
    int cardID,
  ) : this._internal(
          () => LineItems()..cardID = cardID,
          from: lineItemsProvider,
          name: r'lineItemsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$lineItemsHash,
          dependencies: LineItemsFamily._dependencies,
          allTransitiveDependencies: LineItemsFamily._allTransitiveDependencies,
          cardID: cardID,
        );

  LineItemsProvider._internal(
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
  FutureOr<List<LineItem>> runNotifierBuild(
    covariant LineItems notifier,
  ) {
    return notifier.build(
      cardID,
    );
  }

  @override
  Override overrideWith(LineItems Function() create) {
    return ProviderOverride(
      origin: this,
      override: LineItemsProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<LineItems, List<LineItem>>
      createElement() {
    return _LineItemsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LineItemsProvider && other.cardID == cardID;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, cardID.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin LineItemsRef on AutoDisposeAsyncNotifierProviderRef<List<LineItem>> {
  /// The parameter `cardID` of this provider.
  int get cardID;
}

class _LineItemsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<LineItems, List<LineItem>>
    with LineItemsRef {
  _LineItemsProviderElement(super.provider);

  @override
  int get cardID => (origin as LineItemsProvider).cardID;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
