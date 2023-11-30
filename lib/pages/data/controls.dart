part of 'db.dart';

@Riverpod(keepAlive: true)
class Login extends _$Login {
  bool build() => false;

  void login() => state = true;

  void logout() => state = false;
}

@riverpod
class MenuControl extends _$MenuControl {
  MenuControl build(int cardID) => this;

  Future<int> checkOut(double amount, String? note) async {
    final db = ref.read(dbProvider);
    final transDate = DateUtils.dateOnly(DateTime.now());
    final secondsSinceMidnight = DateTime.now().difference(transDate).inSeconds;

    for (final dishID in ref.read(dishIDProvider).requireValue) {
      ref.invalidate(portionProvider(cardID, dishID));
    }
    ref.invalidate(noteProvider(cardID));

    return db.into(db.transactions).insert(
          TransactionsCompanion.insert(
            cardID: cardID,
            date: transDate,
            time: Value(secondsSinceMidnight),
            price: Value(amount),
            note: Value(note),
          ),
        );
  }
}

@Riverpod(keepAlive: true)
class PageStatus extends _$PageStatus {
  @override
  Status build() => Status();

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
