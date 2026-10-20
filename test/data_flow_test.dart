import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:toutim/data/datasources/local/app_database.dart';
import 'package:toutim/data/models/enums/enums.dart';
import 'package:toutim/data/providers/database_provider.dart';
import 'package:toutim/data/providers/repository_providers.dart';
import 'package:toutim/features/collection/providers/collection_providers.dart';
import 'package:toutim/features/home/providers/home_providers.dart';

/// End-to-end data flow through Riverpod providers and an in-memory Drift DB.
void main() {
  late ProviderContainer container;

  setUp(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider
            .overrideWithValue(AppDatabase(NativeDatabase.memory())),
      ],
    );
    addTearDown(container.dispose);
  });

  test('collection, field and tracker item round-trip', () async {
    final collections = container.read(collectionRepositoryProvider);
    final items = container.read(itemRepositoryProvider);

    final collection = await collections.createCollection(
      name: 'Musculation',
      color: 'blue',
    );
    final field = await collections.addFieldDefinition(
      collectionId: collection.id,
      name: 'Poids',
      type: FieldType.tracker,
      sortOrder: 0,
    );

    final listened = container.listen(collectionsStreamProvider, (_, _) {});
    final all = await container.read(collectionsStreamProvider.future);
    expect(all.map((c) => c.name), contains('Musculation'));
    listened.close();

    final entries = [
      {'date': '2026-10-20T10:00:00.000', 'value': 42.5},
    ];
    final created = await items.createItem(
      collectionId: collection.id,
      fieldValues: {field.id: entries},
    );

    final fetched = await items.getItemWithFields(created.item.id);
    expect(fetched, isNotNull);
    expect(fetched!.fieldValues[field.id]?.value, entries);

    final count = container.listen(
      itemCountStreamProvider(collection.id),
      (_, _) {},
    );
    expect(
      await container.read(itemCountStreamProvider(collection.id).future),
      1,
    );
    count.close();

    await collections.deleteCollection(collection.id);
    expect(await items.getItemWithFields(created.item.id), isNull);
  });
}
