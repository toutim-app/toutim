import 'package:drift/drift.dart';

import 'field_definitions_table.dart';
import 'items_table.dart';

/// Drift table for storing dynamic field values per item.
class ItemFieldValues extends Table {
  TextColumn get id => text()();
  TextColumn get itemId => text().references(Items, #id)();
  TextColumn get fieldDefinitionId =>
      text().references(FieldDefinitions, #id)();
  TextColumn get value => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {itemId, fieldDefinitionId},
      ];
}
