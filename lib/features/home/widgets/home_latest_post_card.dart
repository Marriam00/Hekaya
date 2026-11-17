import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/derived_values.dart';
import '../../../data/models.dart';
import '../../shared/widgets/app_buttons.dart';
import '../../shared/widgets/member_avatar.dart';
import '../../shared/widgets/section_heading.dart';

class HomeLatestPostCard extends StatelessWidget {
  const HomeLatestPostCard({
    super.key,
    required this.post,
    required this.author,
    required this.book,
    required this.commentCount,
    required this.onOpenPost,
  });

  final Post? post;
  final Profile? author;
  final Book? book;
  final int commentCount;
  final VoidCallback? onOpenPost;

  @override
  Widget build(BuildContext context) {
    final typography = Theme.of(context).textTheme;
    if (post == null || author == null) {
      return Card(
        color: AppColors.surfaceContainer,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.gutter),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeading(title: 'Reading Corner'),
              const SizedBox(height: AppSpacing.spaceSm),
              Text('No posts yet.', style: typography.bodySmall),
            ],
          ),
        ),
      );
    }

    return Card(
      color: AppColors.surfaceContainer,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.gutter),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeading(title: 'Reading Corner'),
            const SizedBox(height: AppSpacing.gutterCompact),
            Row(
              children: [
                MemberAvatar(
                  name: author!.displayName,
                  imageUrl: author!.avatarUrl,
                  size: AppSpacing.facepileAvatarSize,
                ),
                const SizedBox(width: AppSpacing.spaceSm),
                Expanded(
                  child: Text(
                    author!.displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: typography.labelLarge,
                  ),
                ),
                Text(
                  relativeTime(post!.createdAt),
                  style: typography.labelSmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.gutterCompact),
            Text(
              post!.content,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: typography.bodyMedium,
            ),
            if (book != null) ...[
              const SizedBox(height: AppSpacing.spaceSm),
              Text(
                book!.title,
                style: typography.labelMedium?.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.spaceSm),
            Align(
              alignment: Alignment.centerRight,
              child: AppSecondaryButton(
                label: '$commentCount comments',
                icon: Icons.chat_bubble_outline_rounded,
                onPressed: onOpenPost,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
