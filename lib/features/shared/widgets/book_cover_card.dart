import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_tokens.dart';

class BookCoverCard extends StatelessWidget {
  const BookCoverCard({
    super.key,
    required this.title,
    this.author,
    this.imageUrl,
    this.width = 112,
    this.titleMaxLines = 2,
    this.onTap,
  });

  final String title;
  final String? author;
  final String? imageUrl;
  final double width;
  final int titleMaxLines;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cover = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadii.bookCover),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadii.bookCover),
        child: AspectRatio(
          aspectRatio: 2 / 3,
          child: Stack(
            fit: StackFit.expand,
            children: [
              const ColoredBox(
                color: AppColors.surfaceContainer,
                child: Center(
                  child: Icon(
                    Icons.menu_book_rounded,
                    color: AppColors.onSurfaceVariant,
                    size: 28,
                  ),
                ),
              ),
              if (imageUrl != null && imageUrl!.isNotEmpty)
                Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox(),
                ),
              Positioned(
                left: 5,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 1,
                  color: Colors.black.withValues(alpha: 0.08),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return SizedBox(
      width: width,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.bookCover),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            cover,
            const SizedBox(height: AppSpacing.spaceSm),
            Text(
              title,
              maxLines: titleMaxLines,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium,
            ),
            if (author != null) ...[
              const SizedBox(height: AppSpacing.spaceXs),
              Text(
                author!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
