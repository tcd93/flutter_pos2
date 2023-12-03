import 'package:drift/drift.dart' as d;
import 'package:flutter_pos/database/drift_database.dart';
import 'package:flutter_pos/database/drift_database_test.dart';
import 'package:flutter_pos/p2p/channel.dart';
import 'package:flutter_pos/p2p/syncer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

//flutter drive --target=integration_test/p2p/channel.dart -d windows
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('sqlite group:', () {
    late TestingDriftDB memdb;
    final syncer = Syncer(type: Profile.receiver);
    final date = DateTime(2023, 30, 11);
    final time = 1000;
    final existingTrx =
        Transaction(id: 50, cardID: 0, date: date, time: time, price: 100);

    setUp(() async {
      memdb = TestingDriftDB();

      await memdb.into(memdb.cardItems).insert(
          CardItemsCompanion.insert(id: d.Value(0), pageID: 0, title: 'test'));
      await memdb.into(memdb.transactions).insert(existingTrx);
    });

    tearDown(() async {
      await memdb.close();
    });

    test('ability to merge transactions in syncer', () async {
      final mergingTrx =
          Transaction(id: 100, cardID: 0, date: date, time: time, price: 150);
      final mergingTrx2 = Transaction(
          id: 101, cardID: 0, date: date, time: time + 1, price: 200);
      // send....
      await syncer.sync(
        Profile.receiver,
        memdb,
        Syncer.wrap([mergingTrx, mergingTrx2]),
      );
      final query = memdb.select(memdb.transactions)
        ..where((r) => r.date.equals(date))
        ..orderBy([(u) => d.OrderingTerm.asc(u.id)]);
      final rows = await query.get();
      expect(rows.length, 2);

      final row = rows[0];
      expect(row.id, existingTrx.id);
      expect(row.toJson()..remove('id'), mergingTrx.toJson()..remove('id'));
    });
  });
}
