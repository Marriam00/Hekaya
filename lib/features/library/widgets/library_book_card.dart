import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/models.dart';
import '../../shared/widgets/app_buttons.dart';
import '../../shared/widgets/book_cover_card.dart';
import '../../shared/widgets/status_badge.dart';

class LibraryBookCard extends StatelessWidget {
  const LibraryBookCard({
    super.key,
    required this.book,
    required this.isLent,
    required this.onOpen,
    required this.onEdit,
    required this.onToggleVisibility,
    required this.onViewNotes,
    required this.onDelete,
  });

  final Book book;
  final bool isLent;
  final VoidCallback onOpen;
  final VoidCallback onEdit;
  final VoidCallback onToggleVisibility;
  final VoidCallback onViewNotes;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visibility = book.visibility == BookVisibility.public
        ? 'Public'
        : 'Private';
    final status = isLent
        ? 'Lent Out'
        : switch (book.readingStatus) {
            ReadingStatus.toRead => 'To Read',
            ReadingStatus.reading => 'Reading',
            ReadingStatus.finished => 'Finished',
          };

    return Card(
      color: AppColors.surfaceContainer,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.gutter),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BookCoverCard(
              title: book.title,
              coverReference: book.coverUrl,
              width: AppSpacing.bookCoverWidth,
              showMetadata: false,
            ),
            const SizedBox(width: AppSpacing.gutter),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          book.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                      PopupMenuButton<_BookAction>(
                        tooltip: 'Book actions',
                        onSelected: (action) => switch (action) {
                          _BookAction.edit => onEdit(),
                          _BookAction.visibility => onToggleVisibility(),
                          _BookAction.notes => onViewNotes(),
                          _BookAction.delete => onDelete(),
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: _BookAction.edit,
                            child: Text('Edit'),
                          ),
                          PopupMenuItem(
                            value: _BookAction.visibility,
                            child: Text(
                              book.visibility == BookVisibility.public
                                  ? 'Make Private'
                                  : 'Make Public',
                            ),
                          ),
                          const PopupMenuItem(
                            value: _BookAction.notes,
                            child: Text('View Notes'),
                          ),
                          PopupMenuItem(
                            value: _BookAction.delete,
                            enabled: !isLent,
                            child: Text('Delete'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    book.author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.spaceSm),
                  Wrap(
                    spacing: AppSpacing.spaceXs,
                    runSpacing: AppSpacing.spaceXs,
                    children: [
                      StatusBadge(
                        label: visibility,
                        tone: book.visibility == BookVisibility.public
                            ? StatusBadgeTone.positive
                            : StatusBadgeTone.neutral,
                      ),
                      StatusBadge(
                        label: status,
                        tone: isLent
                            ? StatusBadgeTone.attention
                            : StatusBadgeTone.primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.spaceSm),
                  AppPrimaryButton(
                    label: 'View Details',
                    onPressed: onOpen,
                    backgroundColor: AppColors.primaryContainer,
                    foregroundColor: AppColors.onPrimaryContainer,
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

enum _BookAction { edit, visibility, notes, delete }
