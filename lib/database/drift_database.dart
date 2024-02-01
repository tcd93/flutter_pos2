import 'package:drift/drift.dart';
import 'package:flutter_pos/image_type.dart';
import 'package:logging/logging.dart';

import 'connections/connection.dart' as impl;

part 'drift_database.g.dart';

final _logger = Logger('DriftDB');

@DriftDatabase(include: {'tables.drift'})
class DriftDB extends _$DriftDB {
  DriftDB() : super(impl.connect()) {
    impl.validateDatabaseSchema(this);
  }

  DriftDB.forTesting(super.e);

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        if (details.wasCreated) {
          _logger.info('DB first run: creating default records...');

          await pages.insertAll([
            PagesCompanion.insert(
                id: const Value(0), name: const Value('Page 0')),
            PagesCompanion.insert(
                id: const Value(1), name: const Value('Page 1')),
            PagesCompanion.insert(
                id: const Value(2), name: const Value('Page 2')),
          ]);

          await cardItems.insertAll([
            CardItemsCompanion.insert(pageID: 0, title: 'Ordered Table 1'),
            CardItemsCompanion.insert(pageID: 1, title: 'Sample Table 2'),
            CardItemsCompanion.insert(pageID: 1, title: 'Sample Table 3'),
            CardItemsCompanion.insert(pageID: 2, title: 'Sample Table 4'),
          ]);

          await servings.insertAll([
            ServingsCompanion.insert(cardID: 1, dishID: 1, portion: 2),
            ServingsCompanion.insert(cardID: 1, dishID: 2, portion: 3),
          ]);

          await servingsNote.insertAll([
            ServingsNoteCompanion.insert(
              cardID: const Value(1),
              note: const Value(
                '''Lorem ipsum dolor sit amet, consectetur adipiscing elit.
                  Fusce quam purus, fermentum vel orci ut, rhoncus tincidunt elit.''',
              ),
            ),
          ]);

          await defaultDiscount.insertOne(
            const DefaultDiscountCompanion(rate: Value(1.0)),
          );

          await dishes.insertAll([
            DishesCompanion.insert(
                name: 'apple',
                price: 10,
                imageType: ImageType.asset,
                imagePath: const Value('assets/food/apple.jpg')),
            DishesCompanion.insert(
                name: 'dumpling',
                price: 20,
                imageType: ImageType.asset,
                imagePath: const Value('assets/food/dumpling.jpg')),
            DishesCompanion.insert(
                name: 'icecream',
                price: 30,
                imageType: ImageType.asset,
                imagePath: const Value('assets/food/icecream.jpg')),
            DishesCompanion.insert(
                name: 'pho',
                price: 40,
                imageType: ImageType.asset,
                imagePath: const Value('assets/food/pho.jpg')),
            DishesCompanion.insert(
                name: 'vegetable',
                price: 10,
                imageType: ImageType.asset,
                imagePath: const Value('assets/food/vegetable.jpg')),
            DishesCompanion.insert(
                name: 'cat',
                price: 20,
                imageType: ImageType.asset,
                imagePath: const Value('assets/food/cat.jpg')),
            DishesCompanion.insert(
                name: 'pizza',
                price: 30,
                imageType: ImageType.asset,
                imagePath: const Value('assets/food/pizza.jpg')),
            DishesCompanion.insert(
                name: 'pad thai',
                price: 40,
                imageType: ImageType.asset,
                imagePath: const Value('assets/food/pad_thai.jpg')),
            DishesCompanion.insert(
              name: 'orange',
              price: 10,
              imageType: ImageType.url,
              imagePath: const Value(
                'https://upload.wikimedia.org/wikipedia/commons/thumb/4/43/Ambersweet_oranges.jpg/1200px-Ambersweet_oranges.jpg',
              ),
            ),
          ]);
        }

        await customStatement('PRAGMA foreign_keys = ON;');
      },
    );
  }

  @override
  int get schemaVersion => 1;
}
