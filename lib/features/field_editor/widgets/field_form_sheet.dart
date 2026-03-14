import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/extensions/color_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/enums/field_type.dart';
import '../../../data/models/field_definition.dart';

/// Result returned by [FieldFormSheet] on validation.
class FieldFormResult {
  final String name;
  final FieldType type;
  final bool isRequired;
  final bool showInCard;
  final bool searchable;
  final bool sortable;
  final Map<String, dynamic> options;

  const FieldFormResult({
    required this.name,
    required this.type,
    required this.isRequired,
    required this.showInCard,
    required this.searchable,
    required this.sortable,
    required this.options,
  });
}

/// Bottom sheet for adding or editing a field definition.
class FieldFormSheet extends StatefulWidget {
  final FieldDefinition? definition;

  const FieldFormSheet({super.key, this.definition});

  bool get isEditing => definition != null;

  @override
  State<FieldFormSheet> createState() => _FieldFormSheetState();
}

class _FieldFormSheetState extends State<FieldFormSheet> {
  late final TextEditingController _nameController;
  late FieldType _selectedType;
  late bool _isRequired;
  late bool _showInCard;
  late bool _searchable;
  late bool _sortable;

  // Select options
  late List<String> _selectOptions;
  final _selectOptionController = TextEditingController();

  // Image options
  late String _imageDisplayMode;

  // Tracker options
  late final TextEditingController _trackerUnitController;
  late String _improvementDirection;

  /// Types where searching makes no sense.
  static const _nonSearchableTypes = {
    FieldType.image,
    FieldType.boolean,
    FieldType.rating,
    FieldType.tracker,
  };

  /// Types where sorting makes no sense.
  static const _nonSortableTypes = {
    FieldType.image,
    FieldType.boolean,
    FieldType.tracker,
    FieldType.textArea,
    FieldType.barcode,
  };

  bool get _supportsSearchable => !_nonSearchableTypes.contains(_selectedType);
  bool get _supportsSortable => !_nonSortableTypes.contains(_selectedType);

  static const _supportedTypes = [
    FieldType.text,
    FieldType.textArea,
    FieldType.number,
    FieldType.decimal,
    FieldType.currency,
    FieldType.boolean,
    FieldType.date,
    FieldType.select,
    FieldType.rating,
    FieldType.image,
    FieldType.barcode,
    FieldType.tracker,
  ];

  @override
  void initState() {
    super.initState();
    final def = widget.definition;
    _nameController = TextEditingController(text: def?.name ?? '');
    _selectedType = def?.type ?? FieldType.text;
    _isRequired = def?.isRequired ?? false;
    _showInCard = def?.showInCard ?? true;
    _searchable = def?.searchable ?? true;
    _sortable = def?.sortable ?? false;

    final opts = def?.options ?? {};
    _selectOptions = List<String>.from(opts['options'] ?? []);
    _imageDisplayMode = opts['imageDisplayMode'] as String? ?? 'square';
    _trackerUnitController =
        TextEditingController(text: opts['unit'] as String? ?? '');
    _improvementDirection =
        opts['improvementDirection'] as String? ?? 'up';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _selectOptionController.dispose();
    _trackerUnitController.dispose();
    super.dispose();
  }

  Map<String, dynamic> _buildOptions() {
    final opts = <String, dynamic>{};
    if (_selectedType == FieldType.select && _selectOptions.isNotEmpty) {
      opts['options'] = _selectOptions;
    }
    if (_selectedType == FieldType.image) {
      opts['imageDisplayMode'] = _imageDisplayMode;
    }
    if (_selectedType == FieldType.tracker) {
      if (_trackerUnitController.text.isNotEmpty) {
        opts['unit'] = _trackerUnitController.text;
      }
      opts['improvementDirection'] = _improvementDirection;
    }
    return opts;
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    Navigator.pop(
      context,
      FieldFormResult(
        name: name,
        type: _selectedType,
        isRequired: _isRequired,
        showInCard: _showInCard,
        searchable: _searchable,
        sortable: _sortable,
        options: _buildOptions(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.appBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.isEditing ? 'Modifier le champ' : 'Nouveau champ',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.appTextPrimary,
                  ),
            ),
            const SizedBox(height: 16),

            // Name
            TextFormField(
              controller: _nameController,
              autofocus: !widget.isEditing,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: 'Nom du champ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: context.appBorder),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Type (disabled in edit mode)
            IgnorePointer(
              ignoring: widget.isEditing,
              child: Opacity(
                opacity: widget.isEditing ? 0.5 : 1.0,
                child: DropdownButtonFormField<FieldType>(
                  initialValue: _selectedType,
                  decoration: InputDecoration(
                    labelText: 'Type',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: context.appBorder),
                    ),
                  ),
                  items: _supportedTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Row(
                        children: [
                          Icon(_iconForType(type),
                              size: 18, color: context.appTextSecondary),
                          const SizedBox(width: 8),
                          Text(_labelForType(type)),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _selectedType = value);
                  },
                ),
              ),
            ),

            // Type-specific options
            if (_selectedType == FieldType.select) ...[
              const SizedBox(height: 16),
              _buildSelectOptionsEditor(),
            ],
            if (_selectedType == FieldType.image) ...[
              const SizedBox(height: 16),
              _buildImageOptionsEditor(),
            ],
            if (_selectedType == FieldType.tracker) ...[
              const SizedBox(height: 16),
              _buildTrackerOptionsEditor(),
            ],

            const SizedBox(height: 16),

            // Flags
            _buildSwitch('Requis', _isRequired,
                (v) => setState(() => _isRequired = v)),
            _buildSwitch('Afficher dans la carte', _showInCard,
                (v) => setState(() => _showInCard = v)),
            if (_supportsSearchable) ...[
              _buildSwitch('Cherchable', _searchable,
                  (v) => setState(() => _searchable = v)),
            ],
            if (_supportsSortable) ...[
              _buildSwitch('Triable', _sortable,
                  (v) => setState(() => _sortable = v)),
            ],

            const SizedBox(height: 16),

            FilledButton(
              onPressed: _submit,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(widget.isEditing ? 'Enregistrer' : 'Ajouter'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitch(String label, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.appTextPrimary,
                ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildSelectOptionsEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Options',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: context.appTextSecondary,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        ..._selectOptions.asMap().entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: context.appBorder),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      entry.value,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: context.appTextPrimary,
                          ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    setState(() => _selectOptions.removeAt(entry.key));
                  },
                  child: Icon(LucideIcons.x,
                      size: 18, color: context.appTextTertiary),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _selectOptionController,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Ajouter une option...',
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: context.appBorder),
                  ),
                ),
                onSubmitted: (_) => _addSelectOption(),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _addSelectOption,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(LucideIcons.plus, size: 18, color: AppColors.blue),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _addSelectOption() {
    final text = _selectOptionController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _selectOptions.add(text);
      _selectOptionController.clear();
    });
  }

  Widget _buildImageOptionsEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Affichage dans la carte',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: context.appTextSecondary,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'square', label: Text('Carré')),
              ButtonSegment(value: 'poster', label: Text('Portrait')),
              ButtonSegment(value: 'banner', label: Text('Bannière')),
            ],
            selected: {_imageDisplayMode},
            onSelectionChanged: (v) {
              setState(() => _imageDisplayMode = v.first);
            },
            style: const ButtonStyle(
              visualDensity: VisualDensity.compact,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrackerOptionsEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _trackerUnitController,
          decoration: InputDecoration(
            labelText: 'Unité (ex: kg, km)',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: context.appBorder),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Amélioration',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.appTextPrimary,
                  ),
            ),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'up', label: Text('Plus haut')),
                ButtonSegment(value: 'down', label: Text('Plus bas')),
              ],
              selected: {_improvementDirection},
              onSelectionChanged: (v) {
                setState(() => _improvementDirection = v.first);
              },
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
              ),
            ),
          ],
        ),
      ],
    );
  }

  IconData _iconForType(FieldType type) {
    return switch (type) {
      FieldType.text => LucideIcons.type,
      FieldType.textArea => LucideIcons.alignLeft,
      FieldType.number => LucideIcons.hash,
      FieldType.decimal => LucideIcons.hash,
      FieldType.currency => LucideIcons.banknote,
      FieldType.boolean => LucideIcons.toggleLeft,
      FieldType.date => LucideIcons.calendar,
      FieldType.select => LucideIcons.list,
      FieldType.rating => LucideIcons.star,
      FieldType.image => LucideIcons.image,
      FieldType.barcode => LucideIcons.scanLine,
      FieldType.tracker => LucideIcons.lineChart,
      _ => LucideIcons.circle,
    };
  }

  String _labelForType(FieldType type) {
    return switch (type) {
      FieldType.text => 'Texte',
      FieldType.textArea => 'Texte long',
      FieldType.number => 'Nombre',
      FieldType.decimal => 'Décimal',
      FieldType.currency => 'Monétaire',
      FieldType.boolean => 'Oui / Non',
      FieldType.date => 'Date',
      FieldType.select => 'Liste de choix',
      FieldType.rating => 'Note (étoiles)',
      FieldType.image => 'Image',
      FieldType.barcode => 'Code-barres',
      FieldType.tracker => 'Suivi (graphique)',
      _ => type.name,
    };
  }
}
