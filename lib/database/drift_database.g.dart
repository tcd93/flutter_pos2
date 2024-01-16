// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_database.dart';

// ignore_for_file: type=lint
class Pages extends Table with TableInfo<Pages, Page> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Pages(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _assetMeta = const VerificationMeta('asset');
  late final GeneratedColumn<String> asset = GeneratedColumn<String>(
      'asset', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  @override
  List<GeneratedColumn> get $columns => [id, name, asset];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pages';
  @override
  VerificationContext validateIntegrity(Insertable<Page> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('asset')) {
      context.handle(
          _assetMeta, asset.isAcceptableOrUnknown(data['asset']!, _assetMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Page map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Page(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      asset: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}asset']),
    );
  }

  @override
  Pages createAlias(String alias) {
    return Pages(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Page extends DataClass implements Insertable<Page> {
  final int id;
  final String? name;
  final String? asset;
  const Page({required this.id, this.name, this.asset});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || asset != null) {
      map['asset'] = Variable<String>(asset);
    }
    return map;
  }

  PagesCompanion toCompanion(bool nullToAbsent) {
    return PagesCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      asset:
          asset == null && nullToAbsent ? const Value.absent() : Value(asset),
    );
  }

  factory Page.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Page(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      asset: serializer.fromJson<String?>(json['asset']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String?>(name),
      'asset': serializer.toJson<String?>(asset),
    };
  }

  Page copyWith(
          {int? id,
          Value<String?> name = const Value.absent(),
          Value<String?> asset = const Value.absent()}) =>
      Page(
        id: id ?? this.id,
        name: name.present ? name.value : this.name,
        asset: asset.present ? asset.value : this.asset,
      );
  @override
  String toString() {
    return (StringBuffer('Page(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('asset: $asset')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, asset);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Page &&
          other.id == this.id &&
          other.name == this.name &&
          other.asset == this.asset);
}

class PagesCompanion extends UpdateCompanion<Page> {
  final Value<int> id;
  final Value<String?> name;
  final Value<String?> asset;
  const PagesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.asset = const Value.absent(),
  });
  PagesCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.asset = const Value.absent(),
  });
  static Insertable<Page> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? asset,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (asset != null) 'asset': asset,
    });
  }

  PagesCompanion copyWith(
      {Value<int>? id, Value<String?>? name, Value<String?>? asset}) {
    return PagesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      asset: asset ?? this.asset,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (asset.present) {
      map['asset'] = Variable<String>(asset.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PagesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('asset: $asset')
          ..write(')'))
        .toString();
  }
}

class CardItems extends Table with TableInfo<CardItems, CardItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  CardItems(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  static const VerificationMeta _pageIDMeta = const VerificationMeta('pageID');
  late final GeneratedColumn<int> pageID = GeneratedColumn<int>(
      'pageID', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES pages(id)');
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  @override
  List<GeneratedColumn> get $columns => [id, pageID, title];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cardItems';
  @override
  VerificationContext validateIntegrity(Insertable<CardItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pageID')) {
      context.handle(_pageIDMeta,
          pageID.isAcceptableOrUnknown(data['pageID']!, _pageIDMeta));
    } else if (isInserting) {
      context.missing(_pageIDMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CardItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      pageID: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pageID'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
    );
  }

  @override
  CardItems createAlias(String alias) {
    return CardItems(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class CardItem extends DataClass implements Insertable<CardItem> {
  final int id;
  final int pageID;
  final String title;
  const CardItem({required this.id, required this.pageID, required this.title});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pageID'] = Variable<int>(pageID);
    map['title'] = Variable<String>(title);
    return map;
  }

  CardItemsCompanion toCompanion(bool nullToAbsent) {
    return CardItemsCompanion(
      id: Value(id),
      pageID: Value(pageID),
      title: Value(title),
    );
  }

  factory CardItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardItem(
      id: serializer.fromJson<int>(json['id']),
      pageID: serializer.fromJson<int>(json['pageID']),
      title: serializer.fromJson<String>(json['title']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pageID': serializer.toJson<int>(pageID),
      'title': serializer.toJson<String>(title),
    };
  }

  CardItem copyWith({int? id, int? pageID, String? title}) => CardItem(
        id: id ?? this.id,
        pageID: pageID ?? this.pageID,
        title: title ?? this.title,
      );
  @override
  String toString() {
    return (StringBuffer('CardItem(')
          ..write('id: $id, ')
          ..write('pageID: $pageID, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, pageID, title);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardItem &&
          other.id == this.id &&
          other.pageID == this.pageID &&
          other.title == this.title);
}

class CardItemsCompanion extends UpdateCompanion<CardItem> {
  final Value<int> id;
  final Value<int> pageID;
  final Value<String> title;
  const CardItemsCompanion({
    this.id = const Value.absent(),
    this.pageID = const Value.absent(),
    this.title = const Value.absent(),
  });
  CardItemsCompanion.insert({
    this.id = const Value.absent(),
    required int pageID,
    required String title,
  })  : pageID = Value(pageID),
        title = Value(title);
  static Insertable<CardItem> custom({
    Expression<int>? id,
    Expression<int>? pageID,
    Expression<String>? title,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pageID != null) 'pageID': pageID,
      if (title != null) 'title': title,
    });
  }

  CardItemsCompanion copyWith(
      {Value<int>? id, Value<int>? pageID, Value<String>? title}) {
    return CardItemsCompanion(
      id: id ?? this.id,
      pageID: pageID ?? this.pageID,
      title: title ?? this.title,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (pageID.present) {
      map['pageID'] = Variable<int>(pageID.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardItemsCompanion(')
          ..write('id: $id, ')
          ..write('pageID: $pageID, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }
}

class Dishes extends Table with TableInfo<Dishes, Dish> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Dishes(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _imageTypeMeta =
      const VerificationMeta('imageType');
  late final GeneratedColumnWithTypeConverter<ImageType, int> imageType =
      GeneratedColumn<int>('imageType', aliasedName, false,
              type: DriftSqlType.int,
              requiredDuringInsert: true,
              $customConstraints: 'NOT NULL')
          .withConverter<ImageType>(Dishes.$converterimageType);
  static const VerificationMeta _imagePathMeta =
      const VerificationMeta('imagePath');
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
      'imagePath', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _imageDataMeta =
      const VerificationMeta('imageData');
  late final GeneratedColumn<Uint8List> imageData = GeneratedColumn<Uint8List>(
      'imageData', aliasedName, true,
      type: DriftSqlType.blob,
      requiredDuringInsert: false,
      $customConstraints: '');
  @override
  List<GeneratedColumn> get $columns =>
      [id, price, name, imageType, imagePath, imageData];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dishes';
  @override
  VerificationContext validateIntegrity(Insertable<Dish> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    context.handle(_imageTypeMeta, const VerificationResult.success());
    if (data.containsKey('imagePath')) {
      context.handle(_imagePathMeta,
          imagePath.isAcceptableOrUnknown(data['imagePath']!, _imagePathMeta));
    }
    if (data.containsKey('imageData')) {
      context.handle(_imageDataMeta,
          imageData.isAcceptableOrUnknown(data['imageData']!, _imageDataMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Dish map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Dish(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      imageType: Dishes.$converterimageType.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}imageType'])!),
      imagePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}imagePath']),
      imageData: attachedDatabase.typeMapping
          .read(DriftSqlType.blob, data['${effectivePrefix}imageData']),
    );
  }

  @override
  Dishes createAlias(String alias) {
    return Dishes(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ImageType, int, int> $converterimageType =
      const EnumIndexConverter<ImageType>(ImageType.values);
  @override
  bool get dontWriteConstraints => true;
}

class Dish extends DataClass implements Insertable<Dish> {
  final int id;
  final double price;
  final String name;
  final ImageType imageType;
  final String? imagePath;
  final Uint8List? imageData;
  const Dish(
      {required this.id,
      required this.price,
      required this.name,
      required this.imageType,
      this.imagePath,
      this.imageData});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['price'] = Variable<double>(price);
    map['name'] = Variable<String>(name);
    {
      final converter = Dishes.$converterimageType;
      map['imageType'] = Variable<int>(converter.toSql(imageType));
    }
    if (!nullToAbsent || imagePath != null) {
      map['imagePath'] = Variable<String>(imagePath);
    }
    if (!nullToAbsent || imageData != null) {
      map['imageData'] = Variable<Uint8List>(imageData);
    }
    return map;
  }

  DishesCompanion toCompanion(bool nullToAbsent) {
    return DishesCompanion(
      id: Value(id),
      price: Value(price),
      name: Value(name),
      imageType: Value(imageType),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      imageData: imageData == null && nullToAbsent
          ? const Value.absent()
          : Value(imageData),
    );
  }

  factory Dish.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Dish(
      id: serializer.fromJson<int>(json['id']),
      price: serializer.fromJson<double>(json['price']),
      name: serializer.fromJson<String>(json['name']),
      imageType: Dishes.$converterimageType
          .fromJson(serializer.fromJson<int>(json['imageType'])),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      imageData: serializer.fromJson<Uint8List?>(json['imageData']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'price': serializer.toJson<double>(price),
      'name': serializer.toJson<String>(name),
      'imageType':
          serializer.toJson<int>(Dishes.$converterimageType.toJson(imageType)),
      'imagePath': serializer.toJson<String?>(imagePath),
      'imageData': serializer.toJson<Uint8List?>(imageData),
    };
  }

  Dish copyWith(
          {int? id,
          double? price,
          String? name,
          ImageType? imageType,
          Value<String?> imagePath = const Value.absent(),
          Value<Uint8List?> imageData = const Value.absent()}) =>
      Dish(
        id: id ?? this.id,
        price: price ?? this.price,
        name: name ?? this.name,
        imageType: imageType ?? this.imageType,
        imagePath: imagePath.present ? imagePath.value : this.imagePath,
        imageData: imageData.present ? imageData.value : this.imageData,
      );
  @override
  String toString() {
    return (StringBuffer('Dish(')
          ..write('id: $id, ')
          ..write('price: $price, ')
          ..write('name: $name, ')
          ..write('imageType: $imageType, ')
          ..write('imagePath: $imagePath, ')
          ..write('imageData: $imageData')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, price, name, imageType, imagePath,
      $driftBlobEquality.hash(imageData));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Dish &&
          other.id == this.id &&
          other.price == this.price &&
          other.name == this.name &&
          other.imageType == this.imageType &&
          other.imagePath == this.imagePath &&
          $driftBlobEquality.equals(other.imageData, this.imageData));
}

class DishesCompanion extends UpdateCompanion<Dish> {
  final Value<int> id;
  final Value<double> price;
  final Value<String> name;
  final Value<ImageType> imageType;
  final Value<String?> imagePath;
  final Value<Uint8List?> imageData;
  const DishesCompanion({
    this.id = const Value.absent(),
    this.price = const Value.absent(),
    this.name = const Value.absent(),
    this.imageType = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.imageData = const Value.absent(),
  });
  DishesCompanion.insert({
    this.id = const Value.absent(),
    required double price,
    required String name,
    required ImageType imageType,
    this.imagePath = const Value.absent(),
    this.imageData = const Value.absent(),
  })  : price = Value(price),
        name = Value(name),
        imageType = Value(imageType);
  static Insertable<Dish> custom({
    Expression<int>? id,
    Expression<double>? price,
    Expression<String>? name,
    Expression<int>? imageType,
    Expression<String>? imagePath,
    Expression<Uint8List>? imageData,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (price != null) 'price': price,
      if (name != null) 'name': name,
      if (imageType != null) 'imageType': imageType,
      if (imagePath != null) 'imagePath': imagePath,
      if (imageData != null) 'imageData': imageData,
    });
  }

  DishesCompanion copyWith(
      {Value<int>? id,
      Value<double>? price,
      Value<String>? name,
      Value<ImageType>? imageType,
      Value<String?>? imagePath,
      Value<Uint8List?>? imageData}) {
    return DishesCompanion(
      id: id ?? this.id,
      price: price ?? this.price,
      name: name ?? this.name,
      imageType: imageType ?? this.imageType,
      imagePath: imagePath ?? this.imagePath,
      imageData: imageData ?? this.imageData,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (imageType.present) {
      final converter = Dishes.$converterimageType;

      map['imageType'] = Variable<int>(converter.toSql(imageType.value));
    }
    if (imagePath.present) {
      map['imagePath'] = Variable<String>(imagePath.value);
    }
    if (imageData.present) {
      map['imageData'] = Variable<Uint8List>(imageData.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DishesCompanion(')
          ..write('id: $id, ')
          ..write('price: $price, ')
          ..write('name: $name, ')
          ..write('imageType: $imageType, ')
          ..write('imagePath: $imagePath, ')
          ..write('imageData: $imageData')
          ..write(')'))
        .toString();
  }
}

class Servings extends Table with TableInfo<Servings, Serving> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Servings(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _cardIDMeta = const VerificationMeta('cardID');
  late final GeneratedColumn<int> cardID = GeneratedColumn<int>(
      'cardID', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES cardItems(id)');
  static const VerificationMeta _dishIDMeta = const VerificationMeta('dishID');
  late final GeneratedColumn<int> dishID = GeneratedColumn<int>(
      'dishID', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES dishes(id)');
  static const VerificationMeta _portionMeta =
      const VerificationMeta('portion');
  late final GeneratedColumn<int> portion = GeneratedColumn<int>(
      'portion', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  @override
  List<GeneratedColumn> get $columns => [cardID, dishID, portion];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'servings';
  @override
  VerificationContext validateIntegrity(Insertable<Serving> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('cardID')) {
      context.handle(_cardIDMeta,
          cardID.isAcceptableOrUnknown(data['cardID']!, _cardIDMeta));
    } else if (isInserting) {
      context.missing(_cardIDMeta);
    }
    if (data.containsKey('dishID')) {
      context.handle(_dishIDMeta,
          dishID.isAcceptableOrUnknown(data['dishID']!, _dishIDMeta));
    } else if (isInserting) {
      context.missing(_dishIDMeta);
    }
    if (data.containsKey('portion')) {
      context.handle(_portionMeta,
          portion.isAcceptableOrUnknown(data['portion']!, _portionMeta));
    } else if (isInserting) {
      context.missing(_portionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {cardID, dishID};
  @override
  Serving map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Serving(
      cardID: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cardID'])!,
      dishID: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}dishID'])!,
      portion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}portion'])!,
    );
  }

  @override
  Servings createAlias(String alias) {
    return Servings(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const ['PRIMARY KEY(cardID, dishID)'];
  @override
  bool get dontWriteConstraints => true;
}

class Serving extends DataClass implements Insertable<Serving> {
  final int cardID;
  final int dishID;
  final int portion;
  const Serving(
      {required this.cardID, required this.dishID, required this.portion});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['cardID'] = Variable<int>(cardID);
    map['dishID'] = Variable<int>(dishID);
    map['portion'] = Variable<int>(portion);
    return map;
  }

  ServingsCompanion toCompanion(bool nullToAbsent) {
    return ServingsCompanion(
      cardID: Value(cardID),
      dishID: Value(dishID),
      portion: Value(portion),
    );
  }

  factory Serving.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Serving(
      cardID: serializer.fromJson<int>(json['cardID']),
      dishID: serializer.fromJson<int>(json['dishID']),
      portion: serializer.fromJson<int>(json['portion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cardID': serializer.toJson<int>(cardID),
      'dishID': serializer.toJson<int>(dishID),
      'portion': serializer.toJson<int>(portion),
    };
  }

  Serving copyWith({int? cardID, int? dishID, int? portion}) => Serving(
        cardID: cardID ?? this.cardID,
        dishID: dishID ?? this.dishID,
        portion: portion ?? this.portion,
      );
  @override
  String toString() {
    return (StringBuffer('Serving(')
          ..write('cardID: $cardID, ')
          ..write('dishID: $dishID, ')
          ..write('portion: $portion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(cardID, dishID, portion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Serving &&
          other.cardID == this.cardID &&
          other.dishID == this.dishID &&
          other.portion == this.portion);
}

class ServingsCompanion extends UpdateCompanion<Serving> {
  final Value<int> cardID;
  final Value<int> dishID;
  final Value<int> portion;
  final Value<int> rowid;
  const ServingsCompanion({
    this.cardID = const Value.absent(),
    this.dishID = const Value.absent(),
    this.portion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ServingsCompanion.insert({
    required int cardID,
    required int dishID,
    required int portion,
    this.rowid = const Value.absent(),
  })  : cardID = Value(cardID),
        dishID = Value(dishID),
        portion = Value(portion);
  static Insertable<Serving> custom({
    Expression<int>? cardID,
    Expression<int>? dishID,
    Expression<int>? portion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (cardID != null) 'cardID': cardID,
      if (dishID != null) 'dishID': dishID,
      if (portion != null) 'portion': portion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ServingsCompanion copyWith(
      {Value<int>? cardID,
      Value<int>? dishID,
      Value<int>? portion,
      Value<int>? rowid}) {
    return ServingsCompanion(
      cardID: cardID ?? this.cardID,
      dishID: dishID ?? this.dishID,
      portion: portion ?? this.portion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cardID.present) {
      map['cardID'] = Variable<int>(cardID.value);
    }
    if (dishID.present) {
      map['dishID'] = Variable<int>(dishID.value);
    }
    if (portion.present) {
      map['portion'] = Variable<int>(portion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServingsCompanion(')
          ..write('cardID: $cardID, ')
          ..write('dishID: $dishID, ')
          ..write('portion: $portion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class ServingsNote extends Table
    with TableInfo<ServingsNote, ServingsNoteData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ServingsNote(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _cardIDMeta = const VerificationMeta('cardID');
  late final GeneratedColumn<int> cardID = GeneratedColumn<int>(
      'cardID', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL PRIMARY KEY REFERENCES cardItems(id)');
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  @override
  List<GeneratedColumn> get $columns => [cardID, note];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'servings_note';
  @override
  VerificationContext validateIntegrity(Insertable<ServingsNoteData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('cardID')) {
      context.handle(_cardIDMeta,
          cardID.isAcceptableOrUnknown(data['cardID']!, _cardIDMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {cardID};
  @override
  ServingsNoteData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServingsNoteData(
      cardID: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cardID'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
    );
  }

  @override
  ServingsNote createAlias(String alias) {
    return ServingsNote(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class ServingsNoteData extends DataClass
    implements Insertable<ServingsNoteData> {
  final int cardID;
  final String? note;
  const ServingsNoteData({required this.cardID, this.note});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['cardID'] = Variable<int>(cardID);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  ServingsNoteCompanion toCompanion(bool nullToAbsent) {
    return ServingsNoteCompanion(
      cardID: Value(cardID),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory ServingsNoteData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServingsNoteData(
      cardID: serializer.fromJson<int>(json['cardID']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cardID': serializer.toJson<int>(cardID),
      'note': serializer.toJson<String?>(note),
    };
  }

  ServingsNoteData copyWith(
          {int? cardID, Value<String?> note = const Value.absent()}) =>
      ServingsNoteData(
        cardID: cardID ?? this.cardID,
        note: note.present ? note.value : this.note,
      );
  @override
  String toString() {
    return (StringBuffer('ServingsNoteData(')
          ..write('cardID: $cardID, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(cardID, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServingsNoteData &&
          other.cardID == this.cardID &&
          other.note == this.note);
}

class ServingsNoteCompanion extends UpdateCompanion<ServingsNoteData> {
  final Value<int> cardID;
  final Value<String?> note;
  const ServingsNoteCompanion({
    this.cardID = const Value.absent(),
    this.note = const Value.absent(),
  });
  ServingsNoteCompanion.insert({
    this.cardID = const Value.absent(),
    this.note = const Value.absent(),
  });
  static Insertable<ServingsNoteData> custom({
    Expression<int>? cardID,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (cardID != null) 'cardID': cardID,
      if (note != null) 'note': note,
    });
  }

  ServingsNoteCompanion copyWith({Value<int>? cardID, Value<String?>? note}) {
    return ServingsNoteCompanion(
      cardID: cardID ?? this.cardID,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cardID.present) {
      map['cardID'] = Variable<int>(cardID.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServingsNoteCompanion(')
          ..write('cardID: $cardID, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class Transactions extends Table with TableInfo<Transactions, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Transactions(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  static const VerificationMeta _cardIDMeta = const VerificationMeta('cardID');
  late final GeneratedColumn<int> cardID = GeneratedColumn<int>(
      'cardID', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES cardItems(id)');
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  late final GeneratedColumn<int> time = GeneratedColumn<int>(
      'time', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, true,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  @override
  List<GeneratedColumn> get $columns => [id, cardID, date, time, price, note];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(Insertable<Transaction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cardID')) {
      context.handle(_cardIDMeta,
          cardID.isAcceptableOrUnknown(data['cardID']!, _cardIDMeta));
    } else if (isInserting) {
      context.missing(_cardIDMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('time')) {
      context.handle(
          _timeMeta, time.isAcceptableOrUnknown(data['time']!, _timeMeta));
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {date, time},
      ];
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      cardID: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cardID'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      time: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}time']),
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
    );
  }

  @override
  Transactions createAlias(String alias) {
    return Transactions(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const ['UNIQUE(date, time)'];
  @override
  bool get dontWriteConstraints => true;
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final int id;
  final int cardID;
  final DateTime date;

  ///only the date part (YYYY-MM-DD)
  final int? time;

  ///seconds elapsed since midnight
  final double? price;
  final String? note;
  const Transaction(
      {required this.id,
      required this.cardID,
      required this.date,
      this.time,
      this.price,
      this.note});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cardID'] = Variable<int>(cardID);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || time != null) {
      map['time'] = Variable<int>(time);
    }
    if (!nullToAbsent || price != null) {
      map['price'] = Variable<double>(price);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      cardID: Value(cardID),
      date: Value(date),
      time: time == null && nullToAbsent ? const Value.absent() : Value(time),
      price:
          price == null && nullToAbsent ? const Value.absent() : Value(price),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory Transaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<int>(json['id']),
      cardID: serializer.fromJson<int>(json['cardID']),
      date: serializer.fromJson<DateTime>(json['date']),
      time: serializer.fromJson<int?>(json['time']),
      price: serializer.fromJson<double?>(json['price']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cardID': serializer.toJson<int>(cardID),
      'date': serializer.toJson<DateTime>(date),
      'time': serializer.toJson<int?>(time),
      'price': serializer.toJson<double?>(price),
      'note': serializer.toJson<String?>(note),
    };
  }

  Transaction copyWith(
          {int? id,
          int? cardID,
          DateTime? date,
          Value<int?> time = const Value.absent(),
          Value<double?> price = const Value.absent(),
          Value<String?> note = const Value.absent()}) =>
      Transaction(
        id: id ?? this.id,
        cardID: cardID ?? this.cardID,
        date: date ?? this.date,
        time: time.present ? time.value : this.time,
        price: price.present ? price.value : this.price,
        note: note.present ? note.value : this.note,
      );
  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('cardID: $cardID, ')
          ..write('date: $date, ')
          ..write('time: $time, ')
          ..write('price: $price, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, cardID, date, time, price, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.cardID == this.cardID &&
          other.date == this.date &&
          other.time == this.time &&
          other.price == this.price &&
          other.note == this.note);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<int> id;
  final Value<int> cardID;
  final Value<DateTime> date;
  final Value<int?> time;
  final Value<double?> price;
  final Value<String?> note;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.cardID = const Value.absent(),
    this.date = const Value.absent(),
    this.time = const Value.absent(),
    this.price = const Value.absent(),
    this.note = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    required int cardID,
    required DateTime date,
    this.time = const Value.absent(),
    this.price = const Value.absent(),
    this.note = const Value.absent(),
  })  : cardID = Value(cardID),
        date = Value(date);
  static Insertable<Transaction> custom({
    Expression<int>? id,
    Expression<int>? cardID,
    Expression<DateTime>? date,
    Expression<int>? time,
    Expression<double>? price,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cardID != null) 'cardID': cardID,
      if (date != null) 'date': date,
      if (time != null) 'time': time,
      if (price != null) 'price': price,
      if (note != null) 'note': note,
    });
  }

  TransactionsCompanion copyWith(
      {Value<int>? id,
      Value<int>? cardID,
      Value<DateTime>? date,
      Value<int?>? time,
      Value<double?>? price,
      Value<String?>? note}) {
    return TransactionsCompanion(
      id: id ?? this.id,
      cardID: cardID ?? this.cardID,
      date: date ?? this.date,
      time: time ?? this.time,
      price: price ?? this.price,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cardID.present) {
      map['cardID'] = Variable<int>(cardID.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (time.present) {
      map['time'] = Variable<int>(time.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('cardID: $cardID, ')
          ..write('date: $date, ')
          ..write('time: $time, ')
          ..write('price: $price, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class TransactionDetails extends Table
    with TableInfo<TransactionDetails, TransactionDetail> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  TransactionDetails(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _transIdMeta =
      const VerificationMeta('transId');
  late final GeneratedColumn<int> transId = GeneratedColumn<int>(
      'transId', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES transactions(id)');
  static const VerificationMeta _dishIDMeta = const VerificationMeta('dishID');
  late final GeneratedColumn<int> dishID = GeneratedColumn<int>(
      'dishID', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES dishes(id)');
  static const VerificationMeta _portionMeta =
      const VerificationMeta('portion');
  late final GeneratedColumn<int> portion = GeneratedColumn<int>(
      'portion', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  @override
  List<GeneratedColumn> get $columns => [transId, dishID, portion];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transaction_details';
  @override
  VerificationContext validateIntegrity(Insertable<TransactionDetail> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('transId')) {
      context.handle(_transIdMeta,
          transId.isAcceptableOrUnknown(data['transId']!, _transIdMeta));
    } else if (isInserting) {
      context.missing(_transIdMeta);
    }
    if (data.containsKey('dishID')) {
      context.handle(_dishIDMeta,
          dishID.isAcceptableOrUnknown(data['dishID']!, _dishIDMeta));
    } else if (isInserting) {
      context.missing(_dishIDMeta);
    }
    if (data.containsKey('portion')) {
      context.handle(_portionMeta,
          portion.isAcceptableOrUnknown(data['portion']!, _portionMeta));
    } else if (isInserting) {
      context.missing(_portionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {transId, dishID};
  @override
  TransactionDetail map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionDetail(
      transId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}transId'])!,
      dishID: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}dishID'])!,
      portion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}portion'])!,
    );
  }

  @override
  TransactionDetails createAlias(String alias) {
    return TransactionDetails(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const ['PRIMARY KEY(transId, dishID)'];
  @override
  bool get dontWriteConstraints => true;
}

class TransactionDetail extends DataClass
    implements Insertable<TransactionDetail> {
  final int transId;
  final int dishID;
  final int portion;
  const TransactionDetail(
      {required this.transId, required this.dishID, required this.portion});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['transId'] = Variable<int>(transId);
    map['dishID'] = Variable<int>(dishID);
    map['portion'] = Variable<int>(portion);
    return map;
  }

  TransactionDetailsCompanion toCompanion(bool nullToAbsent) {
    return TransactionDetailsCompanion(
      transId: Value(transId),
      dishID: Value(dishID),
      portion: Value(portion),
    );
  }

  factory TransactionDetail.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionDetail(
      transId: serializer.fromJson<int>(json['transId']),
      dishID: serializer.fromJson<int>(json['dishID']),
      portion: serializer.fromJson<int>(json['portion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'transId': serializer.toJson<int>(transId),
      'dishID': serializer.toJson<int>(dishID),
      'portion': serializer.toJson<int>(portion),
    };
  }

  TransactionDetail copyWith({int? transId, int? dishID, int? portion}) =>
      TransactionDetail(
        transId: transId ?? this.transId,
        dishID: dishID ?? this.dishID,
        portion: portion ?? this.portion,
      );
  @override
  String toString() {
    return (StringBuffer('TransactionDetail(')
          ..write('transId: $transId, ')
          ..write('dishID: $dishID, ')
          ..write('portion: $portion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(transId, dishID, portion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionDetail &&
          other.transId == this.transId &&
          other.dishID == this.dishID &&
          other.portion == this.portion);
}

class TransactionDetailsCompanion extends UpdateCompanion<TransactionDetail> {
  final Value<int> transId;
  final Value<int> dishID;
  final Value<int> portion;
  final Value<int> rowid;
  const TransactionDetailsCompanion({
    this.transId = const Value.absent(),
    this.dishID = const Value.absent(),
    this.portion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionDetailsCompanion.insert({
    required int transId,
    required int dishID,
    required int portion,
    this.rowid = const Value.absent(),
  })  : transId = Value(transId),
        dishID = Value(dishID),
        portion = Value(portion);
  static Insertable<TransactionDetail> custom({
    Expression<int>? transId,
    Expression<int>? dishID,
    Expression<int>? portion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (transId != null) 'transId': transId,
      if (dishID != null) 'dishID': dishID,
      if (portion != null) 'portion': portion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionDetailsCompanion copyWith(
      {Value<int>? transId,
      Value<int>? dishID,
      Value<int>? portion,
      Value<int>? rowid}) {
    return TransactionDetailsCompanion(
      transId: transId ?? this.transId,
      dishID: dishID ?? this.dishID,
      portion: portion ?? this.portion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (transId.present) {
      map['transId'] = Variable<int>(transId.value);
    }
    if (dishID.present) {
      map['dishID'] = Variable<int>(dishID.value);
    }
    if (portion.present) {
      map['portion'] = Variable<int>(portion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionDetailsCompanion(')
          ..write('transId: $transId, ')
          ..write('dishID: $dishID, ')
          ..write('portion: $portion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$DriftDB extends GeneratedDatabase {
  _$DriftDB(QueryExecutor e) : super(e);
  late final Pages pages = Pages(this);
  late final CardItems cardItems = CardItems(this);
  late final Dishes dishes = Dishes(this);
  late final Servings servings = Servings(this);
  late final ServingsNote servingsNote = ServingsNote(this);
  late final Transactions transactions = Transactions(this);
  late final TransactionDetails transactionDetails = TransactionDetails(this);
  late final Trigger insertTransactionDetails = Trigger(
      'CREATE TRIGGER insert_transaction_details AFTER INSERT ON transactions BEGIN INSERT INTO transaction_details (transid, dishID, portion) SELECT new.id, servings.dishID, servings.portion FROM servings WHERE servings.cardID = new.cardID;DELETE FROM servings WHERE cardID = new.cardID;DELETE FROM servings_note WHERE cardID = new.cardID;END',
      'insert_transaction_details');
  Selectable<GetPriceByDateResult> getPriceByDate(DateTime from, DateTime to) {
    return customSelect(
        'SELECT date, SUM(price) AS priceByDate FROM transactions WHERE date BETWEEN ?1 AND ?2 GROUP BY date',
        variables: [
          Variable<DateTime>(from),
          Variable<DateTime>(to)
        ],
        readsFrom: {
          transactions,
        }).map((QueryRow row) => GetPriceByDateResult(
          date: row.read<DateTime>('date'),
          priceByDate: row.readNullable<double>('priceByDate'),
        ));
  }

  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        pages,
        cardItems,
        dishes,
        servings,
        servingsNote,
        transactions,
        transactionDetails,
        insertTransactionDetails
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('transactions',
                limitUpdateKind: UpdateKind.insert),
            result: [
              TableUpdate('transaction_details', kind: UpdateKind.insert),
              TableUpdate('servings', kind: UpdateKind.delete),
              TableUpdate('servings_note', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

class GetPriceByDateResult {
  final DateTime date;
  final double? priceByDate;
  GetPriceByDateResult({
    required this.date,
    this.priceByDate,
  });
}
