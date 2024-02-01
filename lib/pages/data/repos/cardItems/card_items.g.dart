// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_items.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$cardIDHash() => r'b41dfa1c2232e5e99e3e08736f046e843c322f03';

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

abstract class _$CardID extends BuildlessAutoDisposeAsyncNotifier<List<int>> {
  late final int pageID;

  FutureOr<List<int>> build(
    int pageID,
  );
}

/// See also [CardID].
@ProviderFor(CardID)
const cardIDProvider = CardIDFamily();

/// See also [CardID].
class CardIDFamily extends Family<AsyncValue<List<int>>> {
  /// See also [CardID].
  const CardIDFamily();

  /// See also [CardID].
  CardIDProvider call(
    int pageID,
  ) {
    return CardIDProvider(
      pageID,
    );
  }

  @override
  CardIDProvider getProviderOverride(
    covariant CardIDProvider provider,
  ) {
    return call(
      provider.pageID,
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
  String? get name => r'cardIDProvider';
}

/// See also [CardID].
class CardIDProvider
    extends AutoDisposeAsyncNotifierProviderImpl<CardID, List<int>> {
  /// See also [CardID].
  CardIDProvider(
    int pageID,
  ) : this._internal(
          () => CardID()..pageID = pageID,
          from: cardIDProvider,
          name: r'cardIDProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$cardIDHash,
          dependencies: CardIDFamily._dependencies,
          allTransitiveDependencies: CardIDFamily._allTransitiveDependencies,
          pageID: pageID,
        );

  CardIDProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.pageID,
  }) : super.internal();

  final int pageID;

  @override
  FutureOr<List<int>> runNotifierBuild(
    covariant CardID notifier,
  ) {
    return notifier.build(
      pageID,
    );
  }

  @override
  Override overrideWith(CardID Function() create) {
    return ProviderOverride(
      origin: this,
      override: CardIDProvider._internal(
        () => create()..pageID = pageID,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        pageID: pageID,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<CardID, List<int>> createElement() {
    return _CardIDProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CardIDProvider && other.pageID == pageID;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pageID.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CardIDRef on AutoDisposeAsyncNotifierProviderRef<List<int>> {
  /// The parameter `pageID` of this provider.
  int get pageID;
}

class _CardIDProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<CardID, List<int>>
    with CardIDRef {
  _CardIDProviderElement(super.provider);

  @override
  int get pageID => (origin as CardIDProvider).pageID;
}

String _$cardTitleHash() => r'1f11d9d8d93a208e3d021e2d8fa79434dd270828';

abstract class _$CardTitle extends BuildlessAutoDisposeAsyncNotifier<String?> {
  late final int cardID;

  FutureOr<String?> build(
    int cardID,
  );
}

/// See also [CardTitle].
@ProviderFor(CardTitle)
const cardTitleProvider = CardTitleFamily();

/// See also [CardTitle].
class CardTitleFamily extends Family<AsyncValue<String?>> {
  /// See also [CardTitle].
  const CardTitleFamily();

  /// See also [CardTitle].
  CardTitleProvider call(
    int cardID,
  ) {
    return CardTitleProvider(
      cardID,
    );
  }

  @override
  CardTitleProvider getProviderOverride(
    covariant CardTitleProvider provider,
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
  String? get name => r'cardTitleProvider';
}

/// See also [CardTitle].
class CardTitleProvider
    extends AutoDisposeAsyncNotifierProviderImpl<CardTitle, String?> {
  /// See also [CardTitle].
  CardTitleProvider(
    int cardID,
  ) : this._internal(
          () => CardTitle()..cardID = cardID,
          from: cardTitleProvider,
          name: r'cardTitleProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$cardTitleHash,
          dependencies: CardTitleFamily._dependencies,
          allTransitiveDependencies: CardTitleFamily._allTransitiveDependencies,
          cardID: cardID,
        );

  CardTitleProvider._internal(
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
  FutureOr<String?> runNotifierBuild(
    covariant CardTitle notifier,
  ) {
    return notifier.build(
      cardID,
    );
  }

  @override
  Override overrideWith(CardTitle Function() create) {
    return ProviderOverride(
      origin: this,
      override: CardTitleProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<CardTitle, String?> createElement() {
    return _CardTitleProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CardTitleProvider && other.cardID == cardID;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, cardID.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CardTitleRef on AutoDisposeAsyncNotifierProviderRef<String?> {
  /// The parameter `cardID` of this provider.
  int get cardID;
}

class _CardTitleProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<CardTitle, String?>
    with CardTitleRef {
  _CardTitleProviderElement(super.provider);

  @override
  int get cardID => (origin as CardTitleProvider).cardID;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
