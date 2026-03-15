import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/field_definition.dart';

/// Renderer for tags field type — free-form text tags stored as a list of strings.
class TagsFieldRenderer extends StatefulWidget {
  final FieldDefinition definition;
  final dynamic value;
  final ValueChanged<dynamic> onChanged;

  const TagsFieldRenderer({
    super.key,
    required this.definition,
    this.value,
    required this.onChanged,
  });

  @override
  State<TagsFieldRenderer> createState() => _TagsFieldRendererState();
}

class _TagsFieldRendererState extends State<TagsFieldRenderer> {
  late List<String> _tags;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tags = _parseTags(widget.value);
  }

  @override
  void didUpdateWidget(TagsFieldRenderer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _tags = _parseTags(widget.value);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<String> _parseTags(dynamic raw) {
    if (raw is List) return raw.cast<String>().toList();
    return [];
  }

  void _addTag() {
    final text = _controller.text.trim();
    if (text.isEmpty || _tags.contains(text)) return;
    final updated = [..._tags, text];
    setState(() {
      _tags = updated;
      _controller.clear();
    });
    widget.onChanged(updated);
  }

  void _removeTag(String tag) {
    final updated = _tags.where((t) => t != tag).toList();
    setState(() => _tags = updated);
    widget.onChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Input row
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: widget.definition.name,
                  labelStyle: TextStyle(color: context.appTextSecondary),
                  hintText: 'Ajouter un tag...',
                  hintStyle: TextStyle(color: context.appTextTertiary),
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: context.appBorder),
                  ),
                ),
                onSubmitted: (_) => _addTag(),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _addTag,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(LucideIcons.plus, size: 18, color: AppColors.blue),
              ),
            ),
          ],
        ),
        // Chips
        if (_tags.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: _tags.map((tag) {
              return Chip(
                label: Text(
                  tag,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                backgroundColor: AppColors.blue.withValues(alpha: 0.1),
                side: const BorderSide(color: Colors.transparent),
                deleteIcon: Icon(LucideIcons.x,
                    size: 14, color: AppColors.blue.withValues(alpha: 0.7)),
                onDeleted: () => _removeTag(tag),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                visualDensity: VisualDensity.compact,
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
