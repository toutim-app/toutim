import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/theme/app_colors.dart';

/// A horizontal row of selectable color circles.
class ColorPickerRow extends StatelessWidget {
  final String selectedColorKey;
  final ValueChanged<String> onColorSelected;

  const ColorPickerRow({
    super.key,
    required this.selectedColorKey,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: List.generate(AppColors.palette.length, (index) {
        final color = AppColors.palette[index];
        final key = AppColors.paletteKeys[index];
        final isSelected = key == selectedColorKey;

        return GestureDetector(
          onTap: () => onColorSelected(key),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: color, width: 3)
                  : null,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: isSelected
                ? const Icon(LucideIcons.check, color: Colors.white, size: 20)
                : null,
          ),
        );
      }),
    );
  }
}
