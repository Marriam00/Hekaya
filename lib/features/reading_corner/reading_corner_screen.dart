import 'package:flutter/material.dart';

import '../../core/theme/app_tokens.dart';
import '../../data/models.dart';
import '../../data/repositories/repository_scope.dart';
import '../shared/widgets/app_filter_chip.dart';
import '../shared/widgets/app_header.dart';
import 'widgets/post_composer.dart';
import 'widgets/reading_post_card.dart';

enum ReadingCornerFilter { all, withLinkedBook, questions }

class ReadingCornerScreen extends StatefulWidget {
  const ReadingCornerScreen({
    super.key,
    required this.onOpenThread,
    required this.onOpenBook,
    required this.onOpenProfile,
  });

  final ValueChanged<String> onOpenThread;
  final ValueChanged<String> onOpenBook;
  final VoidCallback onOpenProfile;

  @override
  State<ReadingCornerScreen> createState() => _ReadingCornerScreenState();
}

class _ReadingCornerScreenState extends State<ReadingCornerScreen> {
  ReadingCornerFilter _filter = ReadingCornerFilter.all;

  @override
  Widget build(BuildContext context) {
    final repositories = RepositoryScope.of(context);
    return ListenableBuilder(
      listenable: repositories.changes,
      builder: (context, _) {
        final currentProfile = repositories.profiles.currentProfile;
        final ownedBooks = repositories.books.books
            .where((book) => book.ownerId == currentProfile.id)
            .toList();
        final posts = [...repositories.posts.posts]
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        final visiblePosts = posts.where((post) {
          return switch (_filter) {
            ReadingCornerFilter.all => true,
            ReadingCornerFilter.withLinkedBook => post.bookId != null,
            ReadingCornerFilter.questions => post.type == PostType.question,
          };
        }).toList();

        return Column(
          children: [
            AppHeader(
              sectionLabel: 'Reading Corner',
              profileName: currentProfile.displayName,
              profileImageUrl: currentProfile.avatarUrl,
              onProfileTap: widget.onOpenProfile,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pageMargin,
                  AppSpacing.spaceSm,
                  AppSpacing.pageMargin,
                  AppSpacing.spaceXl,
                ),
                children: [
                  Text(
                    'Reading Corner',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: AppSpacing.gutterCompact),
                  PostComposer(
                    books: ownedBooks,
                    onPublish: (content, bookId, type) {
                      repositories.posts.publish(
                        Post(
                          id: 'post-${DateTime.now().microsecondsSinceEpoch}',
                          authorId: currentProfile.id,
                          bookId: bookId,
                          content: content,
                          type: type,
                          createdAt: DateTime.now(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.gutter),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final filter in ReadingCornerFilter.values) ...[
                          if (filter != ReadingCornerFilter.all)
                            const SizedBox(width: AppSpacing.spaceSm),
                          AppFilterChip(
                            label: switch (filter) {
                              ReadingCornerFilter.all => 'All',
                              ReadingCornerFilter.withLinkedBook =>
                                'With Linked Book',
                              ReadingCornerFilter.questions => 'Questions',
                            },
                            selected: _filter == filter,
                            paddedTapTarget: true,
                            onSelected: (_) => setState(() => _filter = filter),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.gutter),
                  if (visiblePosts.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.spaceXl,
                        ),
                        child: Text(
                          'No posts in this view.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    )
                  else
                    for (final post in visiblePosts) ...[
                      ReadingPostCard(
                        post: post,
                        author: repositories.profiles.findProfile(
                          post.authorId,
                        ),
                        book: post.bookId == null
                            ? null
                            : repositories.books.findBook(post.bookId!),
                        commentCount: repositories.posts
                            .commentsFor(post.id)
                            .length,
                        onOpenPost: () => widget.onOpenThread(post.id),
                        onOpenBook: widget.onOpenBook,
                      ),
                      const SizedBox(height: AppSpacing.gutter),
                    ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
