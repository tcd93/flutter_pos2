import 'package:drift/drift.dart';
import 'package:flutter_pos/image_type.dart';

import 'connections/connection.dart' as impl;

part 'drift_database.g.dart';

@DriftDatabase(include: {'tables.drift'})
class DriftDB extends _$DriftDB {
  DriftDB() : super(impl.connect()) {
    impl.validateDatabaseSchema(this);
  }

  DriftDB.forTesting(QueryExecutor e) : super(e);

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        if (details.wasCreated) {
          print('DB first run: creating default records...');

          await this.pages.insertAll([
            PagesCompanion.insert(id: Value(0), name: Value('Page 0')),
            PagesCompanion.insert(id: Value(1), name: Value('Page 1')),
            PagesCompanion.insert(id: Value(2), name: Value('Page 2')),
          ]);

          await this.cardItems.insertAll([
            CardItemsCompanion.insert(pageID: 0, title: 'Ordered Table 1'),
            CardItemsCompanion.insert(pageID: 1, title: 'Sample Table 2'),
            CardItemsCompanion.insert(pageID: 1, title: 'Sample Table 3'),
            CardItemsCompanion.insert(pageID: 2, title: 'Sample Table 4'),
          ]);

          await this.servings.insertAll([
            ServingsCompanion.insert(cardID: 1, dishID: 1, portion: 2),
            ServingsCompanion.insert(cardID: 1, dishID: 2, portion: 3),
          ]);

          await this.servingsNote.insertAll([
            ServingsNoteCompanion.insert(
              cardID: Value(1),
              note: Value(
                '''Lorem ipsum dolor sit amet, consectetur adipiscing elit.
                  Fusce quam purus, fermentum vel orci ut, rhoncus tincidunt elit.''',
              ),
            ),
          ]);

          await this.dishes.insertAll([
            DishesCompanion.insert(
                name: 'apple',
                price: 10,
                imageType: ImageType.asset,
                imagePath: Value('assets/food/apple.jpg')),
            DishesCompanion.insert(
                name: 'dumpling',
                price: 20,
                imageType: ImageType.asset,
                imagePath: Value('assets/food/dumpling.jpg')),
            DishesCompanion.insert(
                name: 'icecream',
                price: 30,
                imageType: ImageType.asset,
                imagePath: Value('assets/food/icecream.jpg')),
            DishesCompanion.insert(
                name: 'pho',
                price: 40,
                imageType: ImageType.asset,
                imagePath: Value('assets/food/pho.jpg')),
            DishesCompanion.insert(
                name: 'vegetable',
                price: 10,
                imageType: ImageType.asset,
                imagePath: Value('assets/food/vegetable.jpg')),
            DishesCompanion.insert(
                name: 'cat',
                price: 20,
                imageType: ImageType.asset,
                imagePath: Value('assets/food/cat.jpg')),
            DishesCompanion.insert(
                name: 'pizza',
                price: 30,
                imageType: ImageType.asset,
                imagePath: Value('assets/food/pizza.jpg')),
            DishesCompanion.insert(
                name: 'pad thai',
                price: 40,
                imageType: ImageType.asset,
                imagePath: Value('assets/food/pad_thai.jpg')),
            DishesCompanion.insert(
              name: 'orange',
              price: 10,
              imageType: ImageType.url,
              imagePath: Value(
                'https://upload.wikimedia.org/wikipedia/commons/thumb/4/43/Ambersweet_oranges.jpg/1200px-Ambersweet_oranges.jpg',
              ),
            ),
          ]);
        }

        await this.customStatement('PRAGMA foreign_keys = ON;');
      },
    );
  }

  @override
  int get schemaVersion => 1;
}
