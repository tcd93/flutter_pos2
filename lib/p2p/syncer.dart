import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_pos/database/drift_database.dart';
import 'package:logging/logging.dart';

final _logger = Logger('Syncer');

class InvalidJsonFormatException extends FormatException {
  final String cause;

  InvalidJsonFormatException([String? cause])
      : cause = cause ?? 'Invalid json format';
}

class Syncer {
  final DriftDB db;

  Syncer(this.db);

  String getType(dynamic json) {
    if (json['record_type'] == null)
      throw InvalidJsonFormatException('no record_type found in json message');
    return json['record_type'];
  }

  /// Produce database records in string format to send over
  Stream<String> parseRecords() async* {
    final pages = await db.select(db.pages).get();
    yield Syncer.wrap(pages);
    _logger.info('Sent: pages');

    final cards = await db.select(db.cardItems).get();
    yield Syncer.wrap(cards);
    _logger.info('Sent: cardItems');

    final dishes = await db.select(db.dishes).get();
    yield Syncer.wrap(dishes);
    _logger.info('Sent: dishes');

    final servings = await db.select(db.servings).get();
    yield Syncer.wrap(servings);
    _logger.info('Sent: servings');

    // TODO: select top 10, loop
    final trans = await db.select(db.transactions).get();
    await for (final sublist in Syncer.wrapTen(trans)) {
      yield sublist;
    }
    _logger.info('Sent: transactions');

    final tranDetails = await db.select(db.transactionDetails).get();
    await for (final sublist in Syncer.wrapTen(tranDetails)) {
      yield sublist;
    }
    _logger.info('Sent: transaction details');

    yield jsonEncode({'record_type': 'Complete'});
  }

  /// Process incoming webrtc messages, content should be Json format and always
  /// include key 'record_type'
  void processMessage(
    String message, {
    required void Function() onReceiveCompleteSignal,
    required void Function() onSenderAcknowledgeSignal,
  }) async {
    try {
      await db.customStatement('PRAGMA foreign_keys = OFF;');
      final json = jsonDecode(message);
      final type = getType(json);

      switch (type) {
        case 'Transaction':
          await syncTransactions(json);
        case 'TransactionDetail':
          await syncTransactionDetails(json);
        case 'Page':
          await syncPages(json);
        case 'CardItem':
          await syncCards(json);
        case 'Serving':
          await syncServings(json);
        case 'Dish':
          await syncDishes(json);
        case 'Complete':
          _logger.info('Complete signal received');
          onReceiveCompleteSignal();
        case 'Acknowledge':
          onSenderAcknowledgeSignal();
          return;
        default:
          _logger.severe("Unknown type from incoming json message: $type");
      }
    } on InvalidJsonFormatException catch (ex) {
      _logger.severe(ex);
    } on FormatException catch (ex, stack) {
      _logger.severe('Error in json decoding', ex, stack);
    } catch (ex, stack) {
      _logger.severe('Unknown error', ex, stack);
    } finally {
      await db.customStatement('PRAGMA foreign_keys = ON;');
    }
  }

  @visibleForTesting
  Future<int?> syncCards(dynamic json) async {
    final cards = _tryUnwrap<CardItem>(json);

    await db.cardItems.insertAll(
      cards,
      onConflict: DoUpdate.withExcluded(
        (old, excluded) {
          return CardItemsCompanion.custom(
            id: excluded.id,
            pageID: excluded.pageID,
            title: excluded.title,
          );
        },
      ),
    );
    return cards.length;
  }

  @visibleForTesting
  Future<int?> syncDishes(dynamic json) async {
    final dishes = _tryUnwrap<Dish>(json);

    await db.dishes.insertAll(
      dishes,
      onConflict: DoUpdate.withExcluded(
        (old, excluded) {
          return DishesCompanion.custom(
            id: excluded.id,
            imageData: excluded.imageData,
            imagePath: excluded.imagePath,
            imageType: excluded.imageType,
            name: excluded.name,
            price: excluded.price,
          );
        },
      ),
    );
    return dishes.length;
  }

  @visibleForTesting
  Future<int?> syncPages(dynamic json) async {
    final pages = _tryUnwrap<Page>(json);

    await db.pages.insertAll(
      pages,
      onConflict: DoUpdate.withExcluded(
        (old, excluded) {
          return PagesCompanion.custom(
            id: excluded.id,
            asset: excluded.asset,
            name: excluded.name,
          );
        },
      ),
    );
    return pages.length;
  }

  @visibleForTesting
  Future<int?> syncServings(dynamic json) async {
    final servings = _tryUnwrap<Serving>(json);

    await db.servings.insertAll(
      servings,
      onConflict: DoUpdate.withExcluded(
        (old, excluded) {
          return ServingsCompanion.custom(
            cardID: excluded.cardID,
            dishID: excluded.dishID,
            portion: excluded.portion,
          );
        },
      ),
    );
    return servings.length;
  }

  @visibleForTesting
  Future<int?> syncTransactionDetails(dynamic json) async {
    final trands = _tryUnwrap<TransactionDetail>(json);

    await db.transactionDetails.insertAll(
      trands,
      onConflict: DoUpdate.withExcluded(
        (old, excluded) {
          return TransactionDetailsCompanion.custom(
            dishID: excluded.dishID,
            portion: excluded.portion,
            transId: excluded.transId,
          );
        },
      ),
    );
    return trands.length;
  }

  /// Process and persist messages into database, return rowcount
  @visibleForTesting
  Future<int?> syncTransactions(dynamic json) async {
    final trans = _tryUnwrap<Transaction>(json);

    await db.transactions.insertAll(
      trans,
      onConflict: DoUpdate.withExcluded(
        (old, excluded) {
          return TransactionsCompanion.custom(
            id: excluded.id,
            cardID: excluded.cardID,
            date: excluded.date,
            time: excluded.time,
            price: excluded.price,
            note: (excluded.note + const Constant(' -merged'))
                .iif(excluded.note.isNotNull(), excluded.note),
          );
        },
        target: [db.transactions.date, db.transactions.time],
      ),
    );
    return trans.length;
  }

  List<T> _tryUnwrap<T>(dynamic json) {
    List<dynamic> records = json['record_details'];
    if (records.isEmpty)
      throw InvalidJsonFormatException('record_details contains empty list');

    // if generic type support factory methods that would be great
    // https://github.com/dart-lang/language/issues/356
    if (T == Transaction) {
      return records.map((r) => Transaction.fromJson(r)).toList() as List<T>;
    }
    if (T == TransactionDetail) {
      return records.map((r) => TransactionDetail.fromJson(r)).toList()
          as List<T>;
    }
    if (T == Page) {
      return records.map((r) => Page.fromJson(r)).toList() as List<T>;
    }
    if (T == CardItem) {
      return records.map((r) => CardItem.fromJson(r)).toList() as List<T>;
    }
    if (T == Serving) {
      return records.map((r) => Serving.fromJson(r)).toList() as List<T>;
    }
    if (T == Dish) {
      return records.map((r) => Dish.fromJson(r)).toList() as List<T>;
    }
    throw 'Sync type ${T.runtimeType} not supported';
  }

  static String acknowledge() {
    return jsonEncode({'record_type': 'Acknowledge'});
  }

  @visibleForTesting
  static String wrap(Iterable<Insertable> data, [bool done = true]) {
    assert(data.isNotEmpty);

    final type = data.first.runtimeType.toString();
    _logger.info('wrapping for type: $type, done status: $done');
    return jsonEncode(
      {'record_type': type, 'done': done, 'record_details': data},
    );
  }

  /// wrap 10 transactions at a time
  @visibleForTesting
  static Stream<String> wrapTen(List<Insertable> data) async* {
    assert(data.isNotEmpty);
    for (int i = 0; i < data.length; i = i + 10) {
      int j = i + 10;
      if (j >= data.length) j = data.length;

      yield wrap(data.sublist(i, j), j == data.length);
    }
  }
}
