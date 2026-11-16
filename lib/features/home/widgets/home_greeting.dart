import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../features/shared/widgets/status_badge.dart';
import '../data/home_mock_data.dart';

class HomeGreeting extends StatelessWidget {
  const HomeGreeting({super.key, required this.data});

  final HomeDashboardData data;

  @override
  Widget build(BuildContext context) {
    final typography = AppTypography.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.greeting,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: typography.headlineMedium,
                  ),
                  Text(
                    data.memberName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: typography.headlineLarge?.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.spaceSm),
            StatusBadge(
              label: data.archivedLabel,
              tone: StatusBadgeTone.positive,
              showDot: true,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.spaceSm),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: AppSpacing.spaceXs),
              child: Icon(Icons.bookmark, color: AppColors.primary, size: 18),
            ),
            const SizedBox(width: AppSpacing.spaceSm),
            Expanded(
              child: Text.rich(
                TextSpan(
                  style: typography.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                  children: [
                    const TextSpan(text: 'Currently immersed in '),
                    TextSpan(
                      text: '“${data.currentlyReadingTitle}”',
                      style: typography.bodySmall?.copyWith(
                        color: AppColors.onSurface,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
