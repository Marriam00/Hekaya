import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_tokens.dart';

class HomeDiscoverBanner extends StatelessWidget {
  const HomeDiscoverBanner({
    super.key,
    required this.titleCount,
    required this.onTap,
  });

  final int titleCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceLow,
      borderRadius: BorderRadius.circular(AppRadii.control),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.control),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.gutter),
          child: Row(
            children: [
              CircleAvatar(
                radius: AppSpacing.brandMarkSize / 2,
                backgroundColor: AppColors.primaryFixed,
                child: const Icon(
                  Icons.explore_outlined,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.gutterCompact),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Discover Circle Books',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      'Explore $titleCount titles circulating across your circle',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.spaceSm),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
