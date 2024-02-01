import 'dart:convert';

import 'package:drift/drift.dart' as d;
import 'package:flutter_pos/database/drift_database.dart';
import 'package:flutter_pos/database/drift_database_test.dart';
import 'package:flutter_pos/p2p/syncer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

//flutter drive --target=integration_test/p2p/channel.dart -d windows
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('sqlite group:', () {
    late final TestingDriftDB memdb = TestingDriftDB();
    late final syncer = Syncer(memdb);
    final date = DateTime(2023, 30, 11);
    const time = 1000;
    final existingTrx = Transaction(
      id: 50,
      cardID: 0,
      date: date,
      time: time,
      price: 100,
      discountRate: 1.0,
    );

    setUp(() async {
      await memdb.into(memdb.pages).insert(PagesCompanion.insert(
          id: const d.Value(0), name: const d.Value('Test Page')));
      await memdb.into(memdb.cardItems).insert(CardItemsCompanion.insert(
          id: const d.Value(0), pageID: 0, title: 'test'));
      await memdb.into(memdb.transactions).insert(existingTrx);
    });

    tearDown(() async {
      await memdb.close();
    });

    test('ability to merge transactions in syncer', () async {
      final mergingTrx = Transaction(
        id: 100,
        cardID: 0,
        date: date,
        time: time,
        price: 150,
        discountRate: 1.0,
      );
      final mergingTrx2 = Transaction(
        id: 101,
        cardID: 0,
        date: date,
        time: time + 1,
        price: 200,
        discountRate: 1.0,
      );
      // send....
      await syncer.syncTransactions(
        jsonDecode(Syncer.wrap([mergingTrx, mergingTrx2])),
      );
      final query = memdb.select(memdb.transactions)
        ..where((r) => r.date.equals(date))
        ..orderBy([(u) => d.OrderingTerm.asc(u.id)]);
      final rows = await query.get();
      expect(rows.length, 2);

      final row = rows[0];
      // expect(row.id, existingTrx.id);
      expect(row.toJson()..remove('id'), mergingTrx.toJson()..remove('id'));
    });

    test('ability to merge pages in syncer', () async {
      const mergingPage = Page(id: 0, name: 'Page 1');
      const mergingPage2 = Page(id: 1, name: 'Page 2');
      // send....
      await syncer.syncPages(
        jsonDecode(Syncer.wrap([mergingPage, mergingPage2])),
      );
      final query = memdb.select(memdb.pages)
        ..where((r) => r.id.isIn([0, 1]))
        ..orderBy([(u) => d.OrderingTerm.asc(u.id)]);
      final rows = await query.get();
      expect(rows.length, 2);

      expect(rows[0].id, 0);
      expect(rows[0].toJson(), mergingPage.toJson());
      expect(rows[1].id, 1);
      expect(rows[1].toJson(), mergingPage2.toJson());
    });
  });
}
