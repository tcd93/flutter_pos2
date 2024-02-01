// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'servings_note.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$noteHash() => r'cc1aa1a72a66ab386f40fe3547faa8123e1b731b';

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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
