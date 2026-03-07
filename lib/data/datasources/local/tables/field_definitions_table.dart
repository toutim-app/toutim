import 'package:drift/drift.dart';

import 'collections_table.dart';

/// Drift table definition for field definitions (collection schema).
class FieldDefinitions extends Table {
  TextColumn get id => text()();
  TextColumn get collectionId => text().references(Collections, #id)();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  TextColumn get type => text()();
  IntColumn get sortOrder => integer()();
  BoolColumn get isRequired =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get showInList =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get showInCard =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get searchable =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get sortable =>
      boolean().withDefault(const Constant(false))();
  TextColumn get defaultValue => text().nullable()();
  TextColumn get options =>
      text().withDefault(const Constant('{}'))();
  TextColumn get syncStatus =>
      text().withDefault(const Constant('pending'))();
  TextColumn get serverId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
