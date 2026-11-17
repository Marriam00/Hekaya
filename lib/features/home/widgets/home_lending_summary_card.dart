import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/derived_values.dart';
import '../../../data/models.dart';
import '../../shared/widgets/app_buttons.dart';
import '../../shared/widgets/section_heading.dart';
import '../../shared/widgets/status_badge.dart';

class HomeLendingSummaryCard extends StatelessWidget {
  const HomeLendingSummaryCard({
    super.key,
    required this.request,
    required this.requestedBook,
    required this.requester,
    required this.activeLoan,
    required this.loanBook,
    required this.borrower,
    required this.activeCount,
    required this.onAccept,
    required this.onDecline,
    required this.onViewLoans,
  });

  final BorrowRequest? request;
  final Book? requestedBook;
  final Profile? requester;
  final Loan? activeLoan;
  final Book? loanBook;
  final Profile? borrower;
  final int activeCount;
  final VoidCallback onAccept;
  final VoidCallback onDecline;
  final VoidCallback onViewLoans;

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
                Expanded(
                  child: SectionHeading(
                    title: 'Circulation & Lending',
                    leadingIcon: Icons.swap_horiz_rounded,
                  ),
                ),
                StatusBadge(
                  label: '$activeCount Active',
                  tone: StatusBadgeTone.primary,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.gutterCompact),
            if (request != null && requestedBook != null && requester != null)
              _RequestSummary(
                book: requestedBook!,
                requester: requester!,
                onAccept: onAccept,
                onDecline: onDecline,
              )
            else
              const _EmptySummary(label: 'No pending requests'),
            const SizedBox(height: AppSpacing.spaceSm),
            if (activeLoan != null && loanBook != null && borrower != null)
              _LoanSummary(
                loan: activeLoan!,
                book: loanBook!,
                borrower: borrower!,
                onViewLoans: onViewLoans,
              )
            else
              const _EmptySummary(label: 'No active loans'),
          ],
        ),
      ),
    );
  }
}

class _RequestSummary extends StatelessWidget {
  const _RequestSummary({
    required this.book,
    required this.requester,
    required this.onAccept,
    required this.onDecline,
  });

  final Book book;
  final Profile requester;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  @override
  Widget build(BuildContext context) {
    return _SummaryContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              style: Theme.of(context).textTheme.bodySmall,
              children: [
                TextSpan(
                  text: requester.displayName,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const TextSpan(text: ' requested '),
                TextSpan(text: '“${book.title}”'),
              ],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.spaceSm),
          Wrap(
            spacing: AppSpacing.spaceSm,
            runSpacing: AppSpacing.spaceSm,
            children: [
              AppPrimaryButton(
                label: 'Accept & Lend',
                icon: Icons.check_rounded,
                onPressed: onAccept,
              ),
              AppSecondaryButton(
                label: 'Decline',
                onPressed: onDecline,
                backgroundColor: AppColors.surfaceHighest,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LoanSummary extends StatelessWidget {
  const _LoanSummary({
    required this.loan,
    required this.book,
    required this.borrower,
    required this.onViewLoans,
  });

  final Loan loan;
  final Book book;
  final Profile borrower;
  final VoidCallback onViewLoans;

  @override
  Widget build(BuildContext context) {
    return _SummaryContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.outbox_outlined, color: AppColors.secondary),
              const SizedBox(width: AppSpacing.spaceSm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lent to ${borrower.displayName}: “${book.title}”',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: AppSpacing.spaceXs),
                    Text(
                      'Due in ${daysUntil(loan.expectedReturnAt)} days',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spaceSm),
          Align(
            alignment: Alignment.centerRight,
            child: AppSecondaryButton(
              label: 'Details',
              onPressed: onViewLoans,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryContainer extends StatelessWidget {
  const _SummaryContainer({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(AppSpacing.gutterCompact),
    decoration: BoxDecoration(
      color: AppColors.surfaceLow,
      borderRadius: BorderRadius.circular(AppRadii.control),
    ),
    child: child,
  );
}

class _EmptySummary extends StatelessWidget {
  const _EmptySummary({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => _SummaryContainer(
    child: Text(
      label,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: AppColors.onSurfaceVariant,
      ),
    ),
  );
}
