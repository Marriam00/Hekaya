import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/models.dart';
import '../../shared/widgets/app_buttons.dart';
import '../../shared/widgets/book_cover_card.dart';
import '../../shared/widgets/status_badge.dart';

class DiscoverBookCard extends StatelessWidget {
  const DiscoverBookCard({
    super.key,
    required this.book,
    required this.owner,
    required this.available,
    required this.requestPending,
    required this.onRequest,
  });

  final Book book;
  final Profile? owner;
  final bool available;
  final bool requestPending;
  final VoidCallback onRequest;

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
                  Text(
                    book.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    book.author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: AppColors.onSurfaceVariant),
                  ),
                  const SizedBox(height: AppSpacing.spaceXs),
                  Text(
                    'Owner: ${owner?.displayName ?? 'Member'}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: AppSpacing.spaceSm),
                  Wrap(
                    spacing: AppSpacing.spaceSm,
                    runSpacing: AppSpacing.spaceSm,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      StatusBadge(
                        label: available ? 'Available' : 'On loan',
                        tone: available
                            ? StatusBadgeTone.positive
                            : StatusBadgeTone.attention,
                      ),
                      AppPrimaryButton(
                        label: requestPending
                            ? 'Requested'
                            : available
                            ? 'Request'
                            : 'Unavailable',
                        onPressed: available && !requestPending
                            ? onRequest
                            : null,
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
