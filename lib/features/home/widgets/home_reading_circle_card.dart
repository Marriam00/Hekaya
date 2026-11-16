import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../features/shared/widgets/member_avatar.dart';
import '../../../features/shared/widgets/app_buttons.dart';
import '../data/home_mock_data.dart';

class HomeReadingCircleCard extends StatelessWidget {
  const HomeReadingCircleCard({
    super.key,
    required this.post,
    required this.onReflectionsTap,
  });

  final HomeReadingCirclePost post;
  final VoidCallback onReflectionsTap;

  @override
  Widget build(BuildContext context) {
    final typography = AppTypography.textTheme;

    return Card(
      color: AppColors.surfaceContainer,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.gutter),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.local_library_outlined,
                  color: AppColors.tertiaryContainer,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.spaceSm),
                Expanded(
                  child: Text(
                    'READING CIRCLE',
                    style: typography.labelSmall?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
                Text(
                  post.timeAgo,
                  style: typography.labelSmall?.copyWith(
                    color: AppColors.outline,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.gutterCompact),
            Row(
              children: [
                MemberAvatar(
                  name: post.memberName,
                  size: 28,
                  backgroundColor: AppColors.primaryContainer,
                  foregroundColor: AppColors.onPrimaryContainer,
                ),
                const SizedBox(width: AppSpacing.spaceSm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.memberName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: typography.labelLarge,
                      ),
                      Text(
                        post.discussionTopic,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: typography.labelSmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.gutterCompact),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.gutterCompact),
              decoration: BoxDecoration(
                color: AppColors.surfaceLow,
                borderRadius: BorderRadius.circular(AppRadii.control),
              ),
              child: Text(
                '“${post.quote}”',
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
                style: typography.titleMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.spaceSm),
            Row(
              children: [
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      style: typography.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                      children: [
                        const TextSpan(text: 'On '),
                        TextSpan(
                          text: post.bookTitle,
                          style: typography.bodySmall?.copyWith(
                            color: AppColors.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: AppSpacing.spaceSm),
                AppSecondaryButton(
                  label: '${post.reflectionCount} reflections',
                  icon: Icons.chat_bubble_outline,
                  backgroundColor: AppColors.surfaceHigh,
                  onPressed: onReflectionsTap,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
