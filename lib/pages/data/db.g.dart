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
String _$priceHash() => r'57fa9a32ad735bd93b175a213535bd3d28359e9e';

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
class PriceFamily extends Family<double?> {
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
class PriceProvider extends AutoDisposeProvider<double?> {
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
    double? Function(PriceRef provider) create,
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
  AutoDisposeProviderElement<double?> createElement() {
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

mixin PriceRef on AutoDisposeProviderRef<double?> {
  /// The parameter `cardID` of this provider.
  int get cardID;
}

class _PriceProviderElement extends AutoDisposeProviderElement<double?>
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

String _$loginHash() => r'4e0b8b799bf87335c441b74e239ce7920a27d270';

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
String _$menuControlHash() => r'effefd3374f3c4bea3264add9c53a6ebecb9f544';

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

String _$pageStatusHash() => r'9038297c47c2201f9a0c11c3a9dc1ba9e79de829';

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
String _$cardIDHash() => r'b25065774c6ad3b44243396a2c55ddea27320639';

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

String _$cardTitleHash() => r'af70a2d9f47e872c42bf3dae2e8f1b386db8a4b4';

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

String _$dishIDHash() => r'f64dacbc4e308ae5fe5a35181e25a9223383e0b9';

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
String _$dishItemHash() => r'a2c50549166b366d0bceaf1496d205f95ae225fe';

abstract class _$DishItem extends BuildlessAutoDisposeAsyncNotifier<Dish> {
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
class DishItemProvider
    extends AutoDisposeAsyncNotifierProviderImpl<DishItem, Dish> {
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
  AutoDisposeAsyncNotifierProviderElement<DishItem, Dish> createElement() {
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

mixin DishItemRef on AutoDisposeAsyncNotifierProviderRef<Dish> {
  /// The parameter `dishID` of this provider.
  int get dishID;
}

class _DishItemProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<DishItem, Dish>
    with DishItemRef {
  _DishItemProviderElement(super.provider);

  @override
  int get dishID => (origin as DishItemProvider).dishID;
}

String _$noteHash() => r'cc1aa1a72a66ab386f40fe3547faa8123e1b731b';

abstract class _$Note extends BuildlessAutoDisposeAsyncNotifier<String?> {
  late final int cardID;

  FutureOr<String?> build(
    int cardID,
  );
}

/// See also [Note].
@ProviderFor(Note)
const noteProvider = NoteFamily();

/// See also [Note].
class NoteFamily extends Family<AsyncValue<String?>> {
  /// See also [Note].
  const NoteFamily();

  /// See also [Note].
  NoteProvider call(
    int cardID,
  ) {
    return NoteProvider(
      cardID,
    );
  }

  @override
  NoteProvider getProviderOverride(
    covariant NoteProvider provider,
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
  String? get name => r'noteProvider';
}

/// See also [Note].
class NoteProvider extends AutoDisposeAsyncNotifierProviderImpl<Note, String?> {
  /// See also [Note].
  NoteProvider(
    int cardID,
  ) : this._internal(
          () => Note()..cardID = cardID,
          from: noteProvider,
          name: r'noteProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product') ? null : _$noteHash,
          dependencies: NoteFamily._dependencies,
          allTransitiveDependencies: NoteFamily._allTransitiveDependencies,
          cardID: cardID,
        );

  NoteProvider._internal(
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
    covariant Note notifier,
  ) {
    return notifier.build(
      cardID,
    );
  }

  @override
  Override overrideWith(Note Function() create) {
    return ProviderOverride(
      origin: this,
      override: NoteProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<Note, String?> createElement() {
    return _NoteProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NoteProvider && other.cardID == cardID;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, cardID.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin NoteRef on AutoDisposeAsyncNotifierProviderRef<String?> {
  /// The parameter `cardID` of this provider.
  int get cardID;
}

class _NoteProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<Note, String?>
    with NoteRef {
  _NoteProviderElement(super.provider);

  @override
  int get cardID => (origin as NoteProvider).cardID;
}

String _$pageIDHash() => r'c12f6fd5ee109955cafdf9882c239288e93672a7';

/// See also [PageID].
@ProviderFor(PageID)
final pageIDProvider =
    AutoDisposeAsyncNotifierProvider<PageID, List<int>>.internal(
  PageID.new,
  name: r'pageIDProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$pageIDHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PageID = AutoDisposeAsyncNotifier<List<int>>;
String _$pageNameHash() => r'129f1e30980311c1941f30742376f36f03f1539a';

abstract class _$PageName extends BuildlessAutoDisposeAsyncNotifier<String?> {
  late final int pageID;

  FutureOr<String?> build(
    int pageID,
  );
}

/// See also [PageName].
@ProviderFor(PageName)
const pageNameProvider = PageNameFamily();

/// See also [PageName].
class PageNameFamily extends Family<AsyncValue<String?>> {
  /// See also [PageName].
  const PageNameFamily();

  /// See also [PageName].
  PageNameProvider call(
    int pageID,
  ) {
    return PageNameProvider(
      pageID,
    );
  }

  @override
  PageNameProvider getProviderOverride(
    covariant PageNameProvider provider,
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
  String? get name => r'pageNameProvider';
}

/// See also [PageName].
class PageNameProvider
    extends AutoDisposeAsyncNotifierProviderImpl<PageName, String?> {
  /// See also [PageName].
  PageNameProvider(
    int pageID,
  ) : this._internal(
          () => PageName()..pageID = pageID,
          from: pageNameProvider,
          name: r'pageNameProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$pageNameHash,
          dependencies: PageNameFamily._dependencies,
          allTransitiveDependencies: PageNameFamily._allTransitiveDependencies,
          pageID: pageID,
        );

  PageNameProvider._internal(
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
  FutureOr<String?> runNotifierBuild(
    covariant PageName notifier,
  ) {
    return notifier.build(
      pageID,
    );
  }

  @override
  Override overrideWith(PageName Function() create) {
    return ProviderOverride(
      origin: this,
      override: PageNameProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<PageName, String?> createElement() {
    return _PageNameProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PageNameProvider && other.pageID == pageID;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pageID.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PageNameRef on AutoDisposeAsyncNotifierProviderRef<String?> {
  /// The parameter `pageID` of this provider.
  int get pageID;
}

class _PageNameProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<PageName, String?>
    with PageNameRef {
  _PageNameProviderElement(super.provider);

  @override
  int get pageID => (origin as PageNameProvider).pageID;
}

String _$portionHash() => r'e967c994d36ffbf20ad5958881521ed51a532047';

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
