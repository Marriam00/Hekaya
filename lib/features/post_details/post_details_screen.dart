import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_tokens.dart';
import '../../data/derived_values.dart';
import '../../data/models.dart';
import '../../data/repositories/repository_scope.dart';
import '../shared/widgets/app_buttons.dart';
import '../shared/widgets/app_header.dart';
import '../shared/widgets/member_avatar.dart';
import '../shared/widgets/status_badge.dart';

class PostDetailsScreen extends StatefulWidget {
  const PostDetailsScreen({
    super.key,
    required this.postId,
    required this.onBack,
    required this.onOpenProfile,
    required this.onOpenBook,
  });

  final String postId;
  final VoidCallback onBack;
  final VoidCallback onOpenProfile;
  final ValueChanged<String> onOpenBook;

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repositories = RepositoryScope.of(context);
    return ListenableBuilder(
      listenable: repositories.changes,
      builder: (context, _) {
        final post = firstOrNull(
          repositories.posts.posts.where((item) => item.id == widget.postId),
        );
        if (post == null) {
          return Column(
            children: [
              AppHeader(
                showBrand: false,
                sectionLabel: 'Post Details',
                onProfileTap: widget.onOpenProfile,
              ),
              const Expanded(child: Center(child: Text('Post not found.'))),
            ],
          );
        }

        final author = repositories.profiles.findProfile(post.authorId);
        final book = post.bookId == null
            ? null
            : repositories.books.findBook(post.bookId!);
        final comments = repositories.posts.commentsFor(post.id);

        return Column(
          children: [
            AppHeader(
              showBrand: false,
              sectionLabel: 'Post Details',
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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: widget.onBack,
                      icon: const Icon(Icons.arrow_back_rounded),
                      label: const Text('Back'),
                    ),
                  ),
                  Card(
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
                                size: AppSpacing.threadAuthorAvatarSize,
                              ),
                              const SizedBox(width: AppSpacing.spaceSm),
                              Expanded(
                                child: Text(
                                  author?.displayName ?? 'Member',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ),
                              Text(
                                relativeTime(post.createdAt),
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: AppColors.onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.gutter),
                          if (post.type == PostType.question) ...[
                            const StatusBadge(
                              label: 'Question',
                              tone: StatusBadgeTone.primary,
                            ),
                            const SizedBox(height: AppSpacing.spaceSm),
                          ],
                          Text(
                            post.content,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          if (book != null) ...[
                            const SizedBox(height: AppSpacing.spaceSm),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: ActionChip(
                                label: Text(book.title),
                                onPressed: () => widget.onOpenBook(book.id),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.gutter),
                  Text(
                    'Comments (${comments.length})',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.spaceSm),
                  if (comments.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.gutter,
                      ),
                      child: Text(
                        'No comments yet.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    )
                  else
                    for (final comment in comments) ...[
                      _CommentCard(
                        comment: comment,
                        author: repositories.profiles.findProfile(
                          comment.authorId,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.spaceSm),
                    ],
                  const SizedBox(height: AppSpacing.gutter),
                  TextField(
                    controller: _commentController,
                    minLines: 2,
                    maxLines: 4,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Add a comment',
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: AppSpacing.spaceSm),
                  Align(
                    alignment: Alignment.centerRight,
                    child: AppPrimaryButton(
                      label: 'Send',
                      icon: Icons.send_rounded,
                      onPressed: _commentController.text.trim().isEmpty
                          ? null
                          : () => _sendComment(post),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _sendComment(Post post) async {
    final repositories = RepositoryScope.of(context);
    await repositories.posts.addComment(
      Comment(
        id: 'comment-${DateTime.now().microsecondsSinceEpoch}',
        postId: post.id,
        authorId: repositories.profiles.currentProfileId,
        content: _commentController.text.trim(),
        createdAt: DateTime.now(),
      ),
    );
    if (mounted) {
      _commentController.clear();
      setState(() {});
    }
  }
}

class _CommentCard extends StatelessWidget {
  const _CommentCard({required this.comment, required this.author});

  final Comment comment;
  final Profile? author;

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
                  size: AppSpacing.threadCommentAvatarSize,
                ),
                const SizedBox(width: AppSpacing.spaceSm),
                Expanded(
                  child: Text(
                    author?.displayName ?? 'Member',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                Text(
                  relativeTime(comment.createdAt),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.spaceSm),
            Text(comment.content, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
