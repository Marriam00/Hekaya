import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../features/shared/widgets/app_buttons.dart';
import '../../../features/shared/widgets/section_heading.dart';
import '../../../features/shared/widgets/status_badge.dart';
import '../data/home_mock_data.dart';

class HomeCirculationCard extends StatefulWidget {
  const HomeCirculationCard({
    super.key,
    required this.data,
    required this.onDecline,
    required this.onDetails,
  });

  final HomeDashboardData data;
  final VoidCallback onDecline;
  final VoidCallback onDetails;

  @override
  State<HomeCirculationCard> createState() => _HomeCirculationCardState();
}

class _HomeCirculationCardState extends State<HomeCirculationCard> {
  bool _accepted = false;

  @override
  Widget build(BuildContext context) {
    final request = widget.data.pendingRequest;
    final loan = widget.data.activeLoan;

    return Card(
      color: AppColors.surfaceContainer,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.gutter),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SectionHeading(
                    title: 'Circulation & Lending',
                    leadingIcon: Icons.swap_horiz,
                  ),
                ),
                const SizedBox(width: AppSpacing.spaceSm),
                StatusBadge(
                  label: '${widget.data.activeCirculationCount} Active',
                  tone: StatusBadgeTone.primary,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.gutter),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.gutterCompact),
              decoration: BoxDecoration(
                color: AppColors.surfaceLow,
                borderRadius: BorderRadius.circular(AppRadii.control),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.spaceSm),
                        child: Container(
                          width: AppSpacing.spaceSm,
                          height: AppSpacing.spaceSm,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.spaceSm),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            style: Theme.of(context).textTheme.bodySmall,
                            children: [
                              TextSpan(
                                text: request.memberName,
                                style: AppTypography.textTheme.bodySmall
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              const TextSpan(text: ' requested '),
                              TextSpan(
                                text: '“${request.bookTitle}”',
                                style: AppTypography.textTheme.bodySmall
                                    ?.copyWith(
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.spaceSm),
                  Wrap(
                    spacing: AppSpacing.spaceSm,
                    runSpacing: AppSpacing.spaceSm,
                    children: [
                      AppPrimaryButton(
                        label: _accepted ? 'Lent out!' : 'Accept & Lend',
                        icon: _accepted ? Icons.check : Icons.done,
                        backgroundColor: _accepted
                            ? AppColors.secondary
                            : AppColors.primary,
                        foregroundColor: _accepted
                            ? AppColors.onSecondary
                            : AppColors.onPrimary,
                        onPressed: _accepted
                            ? null
                            : () => setState(() => _accepted = true),
                      ),
                      AppSecondaryButton(
                        label: 'Decline',
                        backgroundColor: AppColors.surfaceHighest,
                        onPressed: widget.onDecline,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.spaceSm),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.gutterCompact),
              decoration: BoxDecoration(
                color: AppColors.surfaceLow,
                borderRadius: BorderRadius.circular(AppRadii.control),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final metadata = _LoanMetadata(loan: loan);
                  final detailsButton = AppSecondaryButton(
                    label: 'Details',
                    backgroundColor: AppColors.surfaceHigh,
                    onPressed: widget.onDetails,
                  );

                  if (constraints.maxWidth < AppBreakpoints.compactCardWidth) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.outbox_outlined,
                              color: AppColors.secondary,
                              size: 18,
                            ),
                            const SizedBox(width: AppSpacing.spaceSm),
                            Expanded(child: metadata),
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: detailsButton,
                        ),
                      ],
                    );
                  }

                  return Row(
                    children: [
                      const Icon(
                        Icons.outbox_outlined,
                        color: AppColors.secondary,
                        size: 18,
                      ),
                      const SizedBox(width: AppSpacing.spaceSm),
                      Expanded(child: metadata),
                      const SizedBox(width: AppSpacing.spaceSm),
                      detailsButton,
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoanMetadata extends StatelessWidget {
  const _LoanMetadata({required this.loan});

  final HomeActiveLoan loan;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            style: Theme.of(context).textTheme.bodySmall,
            children: [
              const TextSpan(text: 'Lent to '),
              TextSpan(
                text: loan.memberName,
                style: AppTypography.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const TextSpan(text: ': '),
              TextSpan(
                text: '“${loan.bookTitle}”',
                style: AppTypography.textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.spaceXs),
        Row(
          children: [
            const Icon(Icons.schedule, color: AppColors.secondary, size: 14),
            const SizedBox(width: AppSpacing.spaceXs),
            Expanded(
              child: Text(
                'Due in ${loan.daysUntilDue} days',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall
                    ?.copyWith(color: AppColors.secondary),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
