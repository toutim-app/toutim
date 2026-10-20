import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../datasources/local/app_database.dart';

part 'database_provider.g.dart';

/// Provides the singleton AppDatabase instance.
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
}
