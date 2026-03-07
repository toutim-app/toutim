import 'package:drift/drift.dart';

/// Drift table definition for collections.
class Collections extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  TextColumn get description => text().nullable()();
  TextColumn get icon => text().nullable()();
  TextColumn get color => text().withLength(min: 1, max: 20)();
  TextColumn get templateId => text().nullable()();
  TextColumn get viewMode => text().withDefault(const Constant('list'))();
  TextColumn get syncStatus =>
      text().withDefault(const Constant('pending'))();
  TextColumn get serverId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
