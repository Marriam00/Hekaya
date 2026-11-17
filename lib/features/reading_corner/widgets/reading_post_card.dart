import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/derived_values.dart';
import '../../../data/models.dart';
import '../../shared/widgets/app_buttons.dart';
import '../../shared/widgets/member_avatar.dart';
import '../../shared/widgets/status_badge.dart';

class ReadingPostCard extends StatelessWidget {
  const ReadingPostCard({
    super.key,
    required this.post,
    required this.author,
    required this.book,
    required this.commentCount,
    required this.onOpenPost,
    required this.onOpenBook,
  });

  final Post post;
  final Profile? author;
  final Book? book;
  final int commentCount;
  final VoidCallback onOpenPost;
  final ValueChanged<String> onOpenBook;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surfaceContainer,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.gutter),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                MemberAvatar(
                  name: author?.displayName ?? 'Member',
                  imageUrl: author?.avatarUrl,
                  size: AppSpacing.composerAvatarSize,
                ),
                const SizedBox(width: AppSpacing.spaceSm),
                Expanded(
                  child: Text(
                    author?.displayName ?? 'Member',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                Text(
                  relativeTime(post.createdAt),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.gutterCompact),
            if (post.type == PostType.question) ...[
              const StatusBadge(label: 'Question', tone: StatusBadgeTone.primary),
              const SizedBox(height: AppSpacing.spaceSm),
            ],
            Text(post.content, style: Theme.of(context).textTheme.bodyMedium),
            if (book != null) ...[
              const SizedBox(height: AppSpacing.spaceSm),
              ActionChip(
                label: Text(book!.title),
                onPressed: () => onOpenBook(book!.id),
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
