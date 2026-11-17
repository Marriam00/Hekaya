import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_tokens.dart';

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    required this.title,
    this.leadingIcon,
    this.leadingColor = AppColors.primary,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
    this.trailingLabel,
  });

  final String title;
  final IconData? leadingIcon;
  final Color leadingColor;
  final String? actionLabel;
  final IconData? actionIcon;
  final VoidCallback? onAction;
  final String? trailingLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (leadingIcon != null) ...[
          Icon(leadingIcon, color: leadingColor, size: 20),
          const SizedBox(width: AppSpacing.spaceSm),
        ],
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.headlineSmall),
        ),
        if (trailingLabel != null)
          Flexible(
            child: Text(
              trailingLabel!,
              maxLines: 2,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall
                  ?.copyWith(color: AppColors.onSurfaceVariant),
            ),
          ),
        if (actionLabel != null)
          if (actionIcon == null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.spaceSm,
                ),
                minimumSize: const Size(0, AppSpacing.controlHeight),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(actionLabel!),
            )
          else
            TextButton.icon(
              onPressed: onAction,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.spaceSm,
                ),
                minimumSize: const Size(0, AppSpacing.controlHeight),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              icon: Icon(actionIcon, size: 18),
              label: Text(actionLabel!),
            ),
      ],
    );
  }
}
