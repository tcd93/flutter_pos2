part of 'db.dart';

@Riverpod(keepAlive: true)
class Login extends _$Login {
  @override
  bool build() => false;

  void login() => state = true;

  void logout() => state = false;
}

@Riverpod(keepAlive: true)
class PageStatus extends _$PageStatus {
  @override
  Status build() => const Status();

  void current(int pageID) => state = state.copyWith(current: pageID);

  void select(int pageID) => state = state.copyWith(selected: pageID);
}

/// Current opened card in menu page
@Riverpod(keepAlive: true)
class SelectedCard extends _$SelectedCard {
  @override
  int? build() => null;

  void close() => state = null;

  void open(int cardID) => state = cardID;
}
