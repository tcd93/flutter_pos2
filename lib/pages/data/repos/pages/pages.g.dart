// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pages.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$pageIDHash() => r'bfacf1984bf615ded8a9bf2b5a54bdf80e2cd17f';

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
String _$pageNameHash() => r'05e33ce3d5c6fa21c01895298e220604b25acf6a';

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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
