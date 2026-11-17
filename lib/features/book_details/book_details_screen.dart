import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_tokens.dart';
import '../../data/derived_values.dart';
import '../../data/models.dart';
import '../../data/repositories/hekaya_repositories.dart';
import '../../data/repositories/repository_scope.dart';
import '../shared/widgets/app_buttons.dart';
import '../shared/widgets/app_header.dart';
import '../shared/widgets/borrow_request_dialog.dart';
import '../shared/widgets/book_cover_card.dart';
import '../shared/widgets/member_avatar.dart';
import '../shared/widgets/status_badge.dart';

class BookDetailsScreen extends StatelessWidget {
  const BookDetailsScreen({
    super.key,
    required this.bookId,
    required this.onBack,
    required this.onEditBook,
    required this.onOpenProfile,
  });

  final String bookId;
  final VoidCallback onBack;
  final ValueChanged<String> onEditBook;
  final VoidCallback onOpenProfile;

  @override
  Widget build(BuildContext context) {
    final repositories = RepositoryScope.of(context);
    return ListenableBuilder(
      listenable: repositories.changes,
      builder: (context, _) {
        final book = repositories.books.findBook(bookId);
        final currentProfile = repositories.profiles.currentProfile;
        if (book == null) {
          return Column(
            children: [
              AppHeader(
                showBrand: false,
                sectionLabel: 'Book Details',
                onProfileTap: onOpenProfile,
              ),
              const Expanded(child: Center(child: Text('Book not found.'))),
            ],
          );
        }

        final owner = repositories.profiles.findProfile(book.ownerId);
        final isOwner = book.ownerId == currentProfile.id;
        final isAvailable = isBookAvailable(book, repositories.lending.loans);
        final pendingRequests = repositories.lending.requests
            .where(
              (request) =>
                  request.bookId == book.id &&
                  request.ownerId == currentProfile.id &&
                  request.status == BorrowRequestStatus.pending,
            )
            .toList();
        final existingRequest = repositories.lending.requests.any(
          (request) =>
              request.bookId == book.id &&
              request.requesterId == currentProfile.id &&
              request.status == BorrowRequestStatus.pending,
        );

        return Column(
          children: [
            AppHeader(
              showBrand: false,
              sectionLabel: 'Book Details',
              onProfileTap: onOpenProfile,
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
                      onPressed: onBack,
                      icon: const Icon(Icons.arrow_back_rounded),
                      label: const Text('Back'),
                    ),
                  ),
                  Center(
                    child: BookCoverCard(
                      title: book.title,
                      coverReference: book.coverUrl,
                      width: AppSpacing.heroBookCoverWidth,
                      showMetadata: false,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.gutter),
                  Text(
                    book.title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: AppSpacing.spaceXs),
                  Text(
                    book.author,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(color: AppColors.onSurfaceVariant),
                  ),
                  const SizedBox(height: AppSpacing.gutterCompact),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: AppSpacing.spaceSm,
                    runSpacing: AppSpacing.spaceSm,
                    children: [
                      StatusBadge(label: book.genre),
                      StatusBadge(
                        label: isAvailable
                            ? 'Available'
                            : hasActiveLoan(book.id, repositories.lending.loans)
                            ? 'On loan'
                            : 'Not available',
                        tone: isAvailable
                            ? StatusBadgeTone.positive
                            : StatusBadgeTone.attention,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.gutter),
                  Card(
                    color: AppColors.surfaceContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.gutter),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Owner',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const SizedBox(height: AppSpacing.spaceSm),
                          Row(
                            children: [
                              MemberAvatar(
                                name: owner?.displayName ?? 'Member',
                                imageUrl: owner?.avatarUrl,
                                size: AppSpacing.facepileAvatarSize,
                              ),
                              const SizedBox(width: AppSpacing.spaceSm),
                              Expanded(
                                child: Text(
                                  owner?.displayName ?? 'Member',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.gutter),
                          Text(
                            'Description',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const SizedBox(height: AppSpacing.spaceSm),
                          Text(
                            book.description.isEmpty
                                ? 'No description provided.'
                                : book.description,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.gutter),
                  if (isOwner) ...[
                    Wrap(
                      spacing: AppSpacing.spaceSm,
                      runSpacing: AppSpacing.spaceSm,
                      children: [
                        AppPrimaryButton(
                          label: 'Edit',
                          icon: Icons.edit_outlined,
                          onPressed: () => onEditBook(book.id),
                        ),
                        AppSecondaryButton(
                          label: book.visibility == BookVisibility.public
                              ? 'Make Private'
                              : 'Make Public',
                          onPressed: () => repositories.books.setVisibility(
                            book.id,
                            book.visibility == BookVisibility.public
                                ? BookVisibility.private
                                : BookVisibility.public,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.gutter),
                    Text(
                      'Pending requests',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.spaceSm),
                    if (pendingRequests.isEmpty)
                      Text(
                        'No pending requests.',
                        style: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(color: AppColors.onSurfaceVariant),
                      )
                    else
                      for (final request in pendingRequests) ...[
                        _PendingRequestTile(
                          request: request,
                          requester: repositories.profiles.findProfile(
                            request.requesterId,
                          ),
                          onAccept: () =>
                              repositories.lending.acceptRequest(request.id),
                          onDecline: () =>
                              repositories.lending.declineRequest(request.id),
                        ),
                        const SizedBox(height: AppSpacing.spaceSm),
                      ],
                  ] else
                    AppPrimaryButton(
                      label: existingRequest
                          ? 'Request Pending'
                          : 'Request to Borrow',
                      onPressed: isAvailable && !existingRequest
                          ? () => _requestBook(
                              context,
                              repositories: repositories,
                              book: book,
                              owner: owner,
                              requesterId: currentProfile.id,
                            )
                          : null,
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _requestBook(
    BuildContext context, {
    required HekayaRepositories repositories,
    required Book book,
    required Profile? owner,
    required String requesterId,
  }) async {
    if (owner == null) throw StateError('Book owner does not exist.');
    final note = await showBorrowRequestDialog(
      context,
      book: book,
      owner: owner,
    );
    if (note == null) return;
    await repositories.lending.createRequest(
      bookId: book.id,
      requesterId: requesterId,
      ownerId: owner.id,
      message: note,
    );
  }
}

class _PendingRequestTile extends StatelessWidget {
  const _PendingRequestTile({
    required this.request,
    required this.requester,
    required this.onAccept,
    required this.onDecline,
  });

  final BorrowRequest request;
  final Profile? requester;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

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
              requester?.displayName ?? 'Member',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            if (request.message.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.spaceXs),
              Text(
                request.message,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: AppSpacing.spaceSm),
            Wrap(
              spacing: AppSpacing.spaceSm,
              runSpacing: AppSpacing.spaceSm,
              children: [
                AppPrimaryButton(label: 'Accept', onPressed: onAccept),
                AppSecondaryButton(label: 'Decline', onPressed: onDecline),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
