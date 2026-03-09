import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/extensions/collection_extensions.dart';
import '../../../core/extensions/color_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/collection.dart';
import '../../../data/models/item_with_fields.dart';
import '../../../data/providers/repository_providers.dart';
import '../providers/search_providers.dart';

/// Global search screen — searches across all collections and items.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      ref.read(searchQueryProvider.notifier).state = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    final resultsAsync = ref.watch(searchResultsProvider);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: _controller,
          autofocus: true,
          onChanged: _onQueryChanged,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: context.appTextPrimary,
              ),
          decoration: InputDecoration(
            hintText: 'Rechercher...',
            hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: context.appTextTertiary,
                ),
            border: InputBorder.none,
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: Icon(LucideIcons.x,
                        size: 18, color: context.appTextTertiary),
                    onPressed: () {
                      _controller.clear();
                      ref.read(searchQueryProvider.notifier).state = '';
                    },
                  )
                : null,
          ),
        ),
      ),
      body: query.length < 2
          ? _buildInitialState(context)
          : resultsAsync.when(
              data: (results) => results.isEmpty
                  ? _buildEmptyResults(context)
                  : _buildResults(context, results),
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (_, _) => const SizedBox.shrink(),
            ),
    );
  }

  Widget _buildInitialState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.search, size: 48, color: context.appTextTertiary),
          const SizedBox(height: 12),
          Text(
            'Rechercher dans vos collections',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.appTextTertiary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyResults(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.searchX, size: 48, color: context.appTextTertiary),
          const SizedBox(height: 12),
          Text(
            'Aucun résultat',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.appTextTertiary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildResults(BuildContext context, SearchResults results) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        if (results.collections.isNotEmpty) ...[
          _buildSectionHeader(context, 'Collections'),
          ...results.collections.map((c) => _buildCollectionTile(context, c)),
        ],
        if (results.items.isNotEmpty) ...[
          _buildSectionHeader(context, 'Objets'),
          ...results.items.map((item) => _buildItemTile(context, item)),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: context.appTextTertiary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Widget _buildCollectionTile(BuildContext context, Collection collection) {
    final color = collection.resolvedColor;
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          collection.icon ?? '',
          style: const TextStyle(fontSize: 18),
        ),
      ),
      title: Text(
        collection.name,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: context.appTextPrimary,
            ),
      ),
      trailing: Icon(LucideIcons.chevronRight,
          size: 18, color: context.appTextTertiary),
      onTap: () => context.push('/collection/${collection.id}'),
    );
  }

  Widget _buildItemTile(BuildContext context, ItemWithFields itemWithFields) {
    final item = itemWithFields.item;
    final values = itemWithFields.fieldValues.values;

    // Find the first non-null text value as title.
    String title = 'Sans titre';
    for (final fv in values) {
      final v = fv.value;
      if (v is String && v.isNotEmpty) {
        title = v;
        break;
      }
    }

    return FutureBuilder<Collection?>(
      future: ref
          .read(collectionRepositoryProvider)
          .getCollectionById(item.collectionId),
      builder: (context, snapshot) {
        final collection = snapshot.data;
        final color = collection?.resolvedColor ?? AppColors.blue;
        final collectionName = collection?.name ?? '';

        return ListTile(
          leading: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Icon(LucideIcons.fileText, size: 18, color: color),
          ),
          title: Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: context.appTextPrimary,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: collectionName.isNotEmpty
              ? Text(
                  collectionName,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.appTextTertiary,
                      ),
                )
              : null,
          trailing: Icon(LucideIcons.chevronRight,
              size: 18, color: context.appTextTertiary),
          onTap: () => context.push(
            '/collection/${item.collectionId}/item/${item.id}',
          ),
        );
      },
    );
  }
}
