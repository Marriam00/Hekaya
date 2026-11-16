import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_tokens.dart';

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    required this.title,
    this.leadingIcon,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
  });

  final String title;
  final IconData? leadingIcon;
  final String? actionLabel;
  final IconData? actionIcon;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (leadingIcon != null) ...[
          Icon(leadingIcon, color: AppColors.primary, size: 20),
          const SizedBox(width: AppSpacing.spaceSm),
        ],
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.headlineSmall),
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
