import 'package:drift/drift.dart';

import 'collections_table.dart';

/// Drift table definition for items within collections.
class Items extends Table {
  TextColumn get id => text()();
  TextColumn get collectionId => text().references(Collections, #id)();
  BoolColumn get favorite =>
      boolean().withDefault(const Constant(false))();
  TextColumn get syncStatus =>
      text().withDefault(const Constant('pending'))();
  TextColumn get serverId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
