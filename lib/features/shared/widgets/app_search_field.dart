import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_tokens.dart';

class AppSearchField extends StatelessWidget {
  const AppSearchField({
    super.key,
    required this.hintText,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onFilterPressed,
    this.suffixIcon,
    this.suffixTooltip,
    this.onSuffixPressed,
    this.readOnly = false,
    this.onTap,
    this.borderRadius,
    this.fillColor,
    this.hasBorder = true,
  });

  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onFilterPressed;
  final IconData? suffixIcon;
  final String? suffixTooltip;
  final VoidCallback? onSuffixPressed;
  final bool readOnly;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final Color? fillColor;
  final bool hasBorder;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.controlHeight,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        readOnly: readOnly,
        onTap: onTap,
        textInputAction: TextInputAction.search,
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.outline,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 48,
            minHeight: 48,
          ),
          suffixIcon: onSuffixPressed == null && onFilterPressed == null
              ? null
              : IconButton(
                  tooltip: suffixTooltip ?? 'Filter',
                  onPressed: onSuffixPressed ?? onFilterPressed,
                  icon: Icon(suffixIcon ?? Icons.tune_rounded),
                  color: AppColors.onSurfaceVariant,
                ),
          filled: true,
          fillColor: fillColor ?? AppColors.surfaceLowest,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.gutter,
          ),
          border: _borderWithRadius,
          enabledBorder: _borderWithRadius,
          focusedBorder: _borderWithRadius.copyWith(
            borderSide: const BorderSide(color: AppColors.primaryContainer),
          ),
        ),
      ),
    );
  }

  OutlineInputBorder get _borderWithRadius => OutlineInputBorder(
    borderRadius: borderRadius ?? BorderRadius.circular(AppRadii.pill),
    borderSide: hasBorder
        ? const BorderSide(color: AppColors.outlineVariant)
        : BorderSide.none,
  );
}
