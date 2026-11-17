import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/derived_values.dart';
import '../../../data/models.dart';
import '../../../data/repositories/hekaya_repositories.dart';
import '../../shared/widgets/app_buttons.dart';
import '../../shared/widgets/book_cover_card.dart';

class LendingRequestList extends StatelessWidget {
  const LendingRequestList({
    super.key,
    required this.requests,
    required this.repositories,
    required this.incoming,
  });

  final List<BorrowRequest> requests;
  final HekayaRepositories repositories;
  final bool incoming;

  @override
  Widget build(BuildContext context) {
    if (requests.isEmpty) {
      return Center(
        child: Text(
          incoming ? 'No incoming requests.' : 'No sent requests.',
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(color: AppColors.onSurfaceVariant),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.pageMargin),
      itemCount: requests.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.gutter),
      itemBuilder: (context, index) {
        final request = requests[index];
        final book = repositories.books.findBook(request.bookId);
        final otherProfile = repositories.profiles.findProfile(
          incoming ? request.requesterId : request.ownerId,
        );
        return _RequestCard(
          request: request,
          book: book,
          otherProfile: otherProfile,
          incoming: incoming,
          onAccept: () => repositories.lending.acceptRequest(request.id),
          onDecline: () => repositories.lending.declineRequest(request.id),
          onCancel: () => repositories.lending.cancelRequest(request.id),
        );
      },
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({
    required this.request,
    required this.book,
    required this.otherProfile,
    required this.incoming,
    required this.onAccept,
    required this.onDecline,
    required this.onCancel,
  });

  final BorrowRequest request;
  final Book? book;
  final Profile? otherProfile;
  final bool incoming;
  final VoidCallback onAccept;
  final VoidCallback onDecline;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surfaceContainer,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.gutter),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BookCoverCard(
              title: book?.title ?? '',
              coverReference: book?.coverUrl,
              width: AppSpacing.loanBookCoverWidth,
              showMetadata: false,
            ),
            const SizedBox(width: AppSpacing.gutter),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book?.title ?? 'Book unavailable',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    book?.author ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: AppColors.onSurfaceVariant),
                  ),
                  const SizedBox(height: AppSpacing.spaceSm),
                  Text(
                    incoming
                        ? 'Requested by ${otherProfile?.displayName ?? 'Member'}'
                        : 'Owner: ${otherProfile?.displayName ?? 'Member'}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: AppSpacing.spaceSm),
                  Wrap(
                    spacing: AppSpacing.spaceSm,
                    runSpacing: AppSpacing.spaceSm,
                    children: incoming
                        ? [
                            AppPrimaryButton(
                              label: 'Accept',
                              onPressed: onAccept,
                            ),
                            AppSecondaryButton(
                              label: 'Decline',
                              onPressed: onDecline,
                            ),
                          ]
                        : [
                            AppSecondaryButton(
                              label: 'Cancel Request',
                              onPressed: onCancel,
                            ),
                          ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LendingLoanList extends StatelessWidget {
  const LendingLoanList({
    super.key,
    required this.loans,
    required this.repositories,
    required this.borrowed,
  });

  final List<Loan> loans;
  final HekayaRepositories repositories;
  final bool borrowed;

  @override
  Widget build(BuildContext context) {
    if (loans.isEmpty) {
      return Center(
        child: Text(
          borrowed ? 'No books borrowed.' : 'No books lent out.',
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(color: AppColors.onSurfaceVariant),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.pageMargin),
      itemCount: loans.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.gutter),
      itemBuilder: (context, index) {
        final loan = loans[index];
        final book = repositories.books.findBook(loan.bookId);
        final otherProfile = repositories.profiles.findProfile(
          borrowed ? loan.ownerId : loan.borrowerId,
        );
        return _LoanCard(
          loan: loan,
          book: book,
          otherProfile: otherProfile,
          borrowed: borrowed,
          onReturned: () => repositories.lending.markReturned(loan.id),
        );
      },
    );
  }
}

class _LoanCard extends StatelessWidget {
  const _LoanCard({
    required this.loan,
    required this.book,
    required this.otherProfile,
    required this.borrowed,
    required this.onReturned,
  });

  final Loan loan;
  final Book? book;
  final Profile? otherProfile;
  final bool borrowed;
  final VoidCallback onReturned;

  @override
  Widget build(BuildContext context) {
    final due = daysUntil(loan.expectedReturnAt);
    return Card(
      color: AppColors.surfaceContainer,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.gutter),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BookCoverCard(
              title: book?.title ?? '',
              coverReference: book?.coverUrl,
              width: AppSpacing.loanBookCoverWidth,
              showMetadata: false,
            ),
            const SizedBox(width: AppSpacing.gutter),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book?.title ?? 'Book unavailable',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    book?.author ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: AppColors.onSurfaceVariant),
                  ),
                  const SizedBox(height: AppSpacing.spaceSm),
                  Text(
                    borrowed
                        ? 'Owner: ${otherProfile?.displayName ?? 'Member'}'
                        : 'Lent to: ${otherProfile?.displayName ?? 'Member'}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    due == 0 ? 'Due today' : 'Due in $due days',
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: AppColors.onSurfaceVariant),
                  ),
                  const SizedBox(height: AppSpacing.spaceSm),
                  if (!borrowed)
                    AppSecondaryButton(
                      label: 'Mark as Returned',
                      onPressed: onReturned,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
