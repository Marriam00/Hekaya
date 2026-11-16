import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../features/shared/widgets/book_cover_card.dart';
import '../../../features/shared/widgets/section_heading.dart';
import '../../../features/shared/widgets/status_badge.dart';
import '../data/home_mock_data.dart';

class HomeLibraryCard extends StatelessWidget {
  const HomeLibraryCard({
    super.key,
    required this.data,
    required this.onViewLibrary,
  });

  final HomeDashboardData data;
  final VoidCallback onViewLibrary;

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
                const Icon(
                  Icons.inventory_2_outlined,
                  color: AppColors.primary,
                  size: 16,
                ),
                const SizedBox(width: AppSpacing.spaceSm),
                Text(
                  'SANCTUM ARCHIVE',
                  style: Theme.of(context).textTheme.labelSmall
                      ?.copyWith(color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
            SectionHeading(
              title: 'Your Library',
              actionLabel: 'View Library',
              actionIcon: Icons.arrow_forward,
              onAction: onViewLibrary,
            ),
            const SizedBox(height: AppSpacing.gutterCompact),
            Wrap(
              spacing: AppSpacing.spaceSm,
              runSpacing: AppSpacing.spaceSm,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.gutter,
                    vertical: AppSpacing.spaceSm,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLow,
                    borderRadius: BorderRadius.circular(AppRadii.control),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '${data.totalVolumes}',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(width: AppSpacing.spaceSm),
                      Text(
                        'VOLUMES',
                        style: Theme.of(context).textTheme.labelSmall
                            ?.copyWith(color: AppColors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                StatusBadge(
                  label: '${data.publicVolumes} Public',
                  tone: StatusBadgeTone.positive,
                ),
                StatusBadge(
                  label: '${data.privateVolumes} Private',
                  tone: StatusBadgeTone.neutral,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.gutter),
            Text(
              'RECENTLY CATALOGED',
              style: Theme.of(context).textTheme.labelSmall
                  ?.copyWith(color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.spaceSm),
            LayoutBuilder(
              builder: (context, constraints) {
                if (data.recentBooks.isEmpty) {
                  return const SizedBox.shrink();
                }

                final itemSpacing = AppSpacing.spaceSm;
                final itemWidth =
                    (constraints.maxWidth -
                        itemSpacing * (data.recentBooks.length - 1)) /
                    data.recentBooks.length;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (
                      var index = 0;
                      index < data.recentBooks.length;
                      index++
                    ) ...[
                      if (index > 0) const SizedBox(width: AppSpacing.spaceSm),
                      BookCoverCard(
                        width: itemWidth,
                        titleMaxLines: 1,
                        title: data.recentBooks[index].title,
                        imageUrl: data.recentBooks[index].coverUrl,
                      ),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
