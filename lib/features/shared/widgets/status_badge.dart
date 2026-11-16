import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_tokens.dart';

enum StatusBadgeTone { neutral, positive, attention, primary }

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.label,
    this.tone = StatusBadgeTone.neutral,
    this.showDot = false,
    this.bordered = false,
  });

  final String label;
  final StatusBadgeTone tone;
  final bool showDot;
  final bool bordered;

  @override
  Widget build(BuildContext context) {
    final (backgroundColor, foregroundColor) = switch (tone) {
      StatusBadgeTone.neutral => (
        AppColors.surfaceHighest,
        AppColors.onSurfaceVariant,
      ),
      StatusBadgeTone.positive => (
        AppColors.secondaryContainer,
        AppColors.onSecondaryContainer,
      ),
      StatusBadgeTone.attention => (
        AppColors.tertiaryFixed,
        AppColors.onTertiaryFixedVariant,
      ),
      StatusBadgeTone.primary => (
        AppColors.primaryFixed,
        AppColors.onPrimaryFixedVariant,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.gutterCompact,
        vertical: AppSpacing.spaceXs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadii.pill),
        border: bordered
            ? Border.all(color: foregroundColor.withValues(alpha: 0.25))
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: foregroundColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSpacing.spaceXs),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall
                ?.copyWith(color: foregroundColor),
          ),
        ],
      ),
    );
  }
}
