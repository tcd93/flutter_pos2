// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ephemeral.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

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
