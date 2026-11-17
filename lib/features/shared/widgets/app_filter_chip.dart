import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_tokens.dart';

class AppFilterChip extends StatelessWidget {
  const AppFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
    this.selectedColor,
    this.selectedForegroundColor,
    this.borderRadius,
    this.labelStyle,
    this.backgroundColor,
    this.unselectedForegroundColor,
    this.paddedTapTarget = false,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;
  final Color? selectedColor;
  final Color? selectedForegroundColor;
  final BorderRadius? borderRadius;
  final TextStyle? labelStyle;
  final Color? backgroundColor;
  final Color? unselectedForegroundColor;
  final bool paddedTapTarget;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      showCheckmark: false,
      materialTapTargetSize: paddedTapTarget
          ? MaterialTapTargetSize.padded
          : MaterialTapTargetSize.shrinkWrap,
      visualDensity: paddedTapTarget
          ? VisualDensity.standard
          : VisualDensity.compact,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.gutterCompact,
        vertical: AppSpacing.spaceXs,
      ),
      labelStyle: (labelStyle ?? Theme.of(context).textTheme.labelMedium)
          ?.copyWith(
            color: selected
                ? (selectedForegroundColor ?? AppColors.onPrimary)
                : (unselectedForegroundColor ?? AppColors.onSurfaceVariant),
          ),
      backgroundColor: backgroundColor ?? AppColors.surfaceContainer,
      selectedColor: selectedColor ?? AppColors.primary,
      shape: borderRadius == null
          ? const StadiumBorder()
          : RoundedRectangleBorder(borderRadius: borderRadius!),
      side: BorderSide.none,
    );
  }
}
