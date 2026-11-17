import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_tokens.dart';
import '../../data/derived_values.dart';
import '../../data/models.dart';
import '../../data/repositories/repository_scope.dart';
import '../shared/widgets/app_buttons.dart';
import '../shared/widgets/app_header.dart';
import '../shared/widgets/book_cover_card.dart';
import '../shared/widgets/member_avatar.dart';
import '../shared/widgets/section_heading.dart';

class MemberProfileScreen extends StatelessWidget {
  const MemberProfileScreen({
    super.key,
    required this.onOpenSettings,
    required this.onOpenBook,
    required this.onOpenPost,
    this.profileId = 'karim',
  });

  final String profileId;
  final VoidCallback onOpenSettings;
  final ValueChanged<String> onOpenBook;
  final ValueChanged<String> onOpenPost;

  @override
  Widget build(BuildContext context) {
    final repositories = RepositoryScope.of(context);
    return ListenableBuilder(
      listenable: repositories.changes,
      builder: (context, _) {
        final current = repositories.profiles.currentProfile;
        final member = repositories.profiles.findProfile(profileId);
        final books =
            repositories.books.books
                .where(
                  (book) =>
                      book.ownerId == profileId &&
                      book.visibility == BookVisibility.public,
                )
                .toList()
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        final latestPost =
            repositories.posts.posts
                .where((post) => post.authorId == profileId)
                .toList()
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        final post = firstOrNull(latestPost);

        return Column(
          children: [
            AppHeader(
              sectionLabel: 'Member Profile',
              profileName: current.displayName,
              profileImageUrl: current.avatarUrl,
              onProfileTap: onOpenSettings,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pageMargin,
                  AppSpacing.spaceLg,
                  AppSpacing.pageMargin,
                  AppSpacing.spaceXl,
                ),
                children: [
                  if (member == null)
                    Center(
                      child: Text(
                        'Member not found.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    )
                  else ...[
                    Center(
                      child: MemberAvatar(
                        name: member.displayName,
                        imageUrl: member.avatarUrl,
                        size: AppSpacing.settingsAvatarSize,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.gutter),
                    Text(
                      member.displayName,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: AppSpacing.spaceXs),
                    Text(
                      'Member since ${_memberSince(member.createdAt)}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: AppColors.onSurfaceVariant),
                    ),
                    if (member.bio.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.gutter),
                      Text(
                        member.bio,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                    const SizedBox(height: AppSpacing.spaceLg),
                    SectionHeading(title: 'Public Books (${books.length})'),
                    const SizedBox(height: AppSpacing.gutterCompact),
                    if (books.isEmpty)
                      Text(
                        'No public books.',
                        style: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(color: AppColors.onSurfaceVariant),
                      )
                    else
                      for (final book in books) ...[
                        _PublicBookCard(
                          book: book,
                          onOpen: () => onOpenBook(book.id),
                        ),
                        const SizedBox(height: AppSpacing.gutterCompact),
                      ],
                    const SizedBox(height: AppSpacing.spaceLg),
                    SectionHeading(title: 'Latest Post'),
                    const SizedBox(height: AppSpacing.gutterCompact),
                    if (post == null)
                      Text(
                        'No posts yet.',
                        style: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(color: AppColors.onSurfaceVariant),
                      )
                    else
                      _LatestPostCard(
                        post: post,
                        book: post.bookId == null
                            ? null
                            : repositories.books.findBook(post.bookId!),
                        commentCount: repositories.posts
                            .commentsFor(post.id)
                            .length,
                        onOpen: () => onOpenPost(post.id),
                      ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  String _memberSince(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}

class _PublicBookCard extends StatelessWidget {
  const _PublicBookCard({required this.book, required this.onOpen});

  final Book book;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surfaceContainer,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.gutter),
        child: Row(
          children: [
            BookCoverCard(
              title: book.title,
              coverReference: book.coverUrl,
              width: AppSpacing.profileBookCoverWidth,
              showMetadata: false,
            ),
            const SizedBox(width: AppSpacing.gutter),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    book.author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: AppColors.onSurfaceVariant),
                  ),
                  const SizedBox(height: AppSpacing.spaceSm),
                  AppPrimaryButton(label: 'View Book', onPressed: onOpen),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LatestPostCard extends StatelessWidget {
  const _LatestPostCard({
    required this.post,
    required this.book,
    required this.commentCount,
    required this.onOpen,
  });

  final Post post;
  final Book? book;
  final int commentCount;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surfaceContainer,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.gutter),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              relativeTime(post.createdAt),
              style: Theme.of(context).textTheme.labelSmall
                  ?.copyWith(color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.spaceSm),
            Text(post.content, style: Theme.of(context).textTheme.bodyMedium),
            if (book != null) ...[
              const SizedBox(height: AppSpacing.spaceSm),
              Text(
                book!.title,
                style: Theme.of(context).textTheme.labelMedium
                    ?.copyWith(color: AppColors.primary),
              ),
            ],
            const SizedBox(height: AppSpacing.spaceSm),
            Align(
              alignment: Alignment.centerRight,
              child: AppSecondaryButton(
                label: '$commentCount comments',
                onPressed: onOpen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
