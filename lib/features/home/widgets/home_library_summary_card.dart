import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/models.dart';
import '../../shared/widgets/book_cover_card.dart';
import '../../shared/widgets/section_heading.dart';
import '../../shared/widgets/status_badge.dart';

class HomeLibrarySummaryCard extends StatelessWidget {
  const HomeLibrarySummaryCard({
    super.key,
    required this.books,
    required this.onViewLibrary,
  });

  final List<Book> books;
  final VoidCallback onViewLibrary;

  @override
  Widget build(BuildContext context) {
    final publicCount = books
        .where((book) => book.visibility == BookVisibility.public)
        .length;
    final privateCount = books.length - publicCount;
    final recentBooks = [...books]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final recent = recentBooks.take(4).toList();

    return Card(
      color: AppColors.surfaceContainer,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.gutter),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                Text(
                  '${books.length} volumes',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                StatusBadge(
                  label: '$publicCount Public',
                  tone: StatusBadgeTone.positive,
                ),
                StatusBadge(
                  label: '$privateCount Private',
                  tone: StatusBadgeTone.neutral,
                ),
              ],
            ),
            if (recent.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.gutter),
              LayoutBuilder(
                builder: (context, constraints) {
                  final gap = AppSpacing.spaceSm;
                  final width =
                      (constraints.maxWidth - gap * (recent.length - 1)) /
                      recent.length;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var index = 0; index < recent.length; index++) ...[
                        if (index > 0)
                          const SizedBox(width: AppSpacing.spaceSm),
                        BookCoverCard(
                          title: recent[index].title,
                          coverReference: recent[index].coverUrl,
                          width: width,
                          titleMaxLines: 1,
                        ),
                      ],
                    ],
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
