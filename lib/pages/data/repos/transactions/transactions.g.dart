// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$transactionHash() => r'847ec9819b41b5ada087f5e6b8f05ee53a18e992';

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

abstract class _$Transaction extends BuildlessAutoDisposeNotifier<Transaction> {
  late final int cardID;

  Transaction build(
    int cardID,
  );
}

/// See also [Transaction].
@ProviderFor(Transaction)
const transactionProvider = TransactionFamily();

/// See also [Transaction].
class TransactionFamily extends Family<Transaction> {
  /// See also [Transaction].
  const TransactionFamily();

  /// See also [Transaction].
  TransactionProvider call(
    int cardID,
  ) {
    return TransactionProvider(
      cardID,
    );
  }

  @override
  TransactionProvider getProviderOverride(
    covariant TransactionProvider provider,
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
  String? get name => r'transactionProvider';
}

/// See also [Transaction].
class TransactionProvider
    extends AutoDisposeNotifierProviderImpl<Transaction, Transaction> {
  /// See also [Transaction].
  TransactionProvider(
    int cardID,
  ) : this._internal(
          () => Transaction()..cardID = cardID,
          from: transactionProvider,
          name: r'transactionProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$transactionHash,
          dependencies: TransactionFamily._dependencies,
          allTransitiveDependencies:
              TransactionFamily._allTransitiveDependencies,
          cardID: cardID,
        );

  TransactionProvider._internal(
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
  Transaction runNotifierBuild(
    covariant Transaction notifier,
  ) {
    return notifier.build(
      cardID,
    );
  }

  @override
  Override overrideWith(Transaction Function() create) {
    return ProviderOverride(
      origin: this,
      override: TransactionProvider._internal(
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
  AutoDisposeNotifierProviderElement<Transaction, Transaction> createElement() {
    return _TransactionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TransactionProvider && other.cardID == cardID;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, cardID.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TransactionRef on AutoDisposeNotifierProviderRef<Transaction> {
  /// The parameter `cardID` of this provider.
  int get cardID;
}

class _TransactionProviderElement
    extends AutoDisposeNotifierProviderElement<Transaction, Transaction>
    with TransactionRef {
  _TransactionProviderElement(super.provider);

  @override
  int get cardID => (origin as TransactionProvider).cardID;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
