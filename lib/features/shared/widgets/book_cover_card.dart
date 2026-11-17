import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_tokens.dart';
import 'book_cover_image.dart';

class BookCoverCard extends StatelessWidget {
  const BookCoverCard({
    super.key,
    required this.title,
    this.author,
    this.coverReference,
    this.width = 112,
    this.aspectRatio = 2 / 3,
    this.titleMaxLines = 2,
    this.showMetadata = true,
    this.borderRadius,
    this.onTap,
  });

  final String title;
  final String? author;
  final String? coverReference;
  final double width;
  final double aspectRatio;
  final int titleMaxLines;
  final bool showMetadata;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final coverRadius =
        borderRadius ?? BorderRadius.circular(AppRadii.bookCover);
    final cover = Container(
      decoration: BoxDecoration(
        borderRadius: coverRadius,
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: ClipRRect(
        borderRadius: coverRadius,
        child: AspectRatio(
          aspectRatio: aspectRatio,
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
              if (coverReference != null && coverReference!.isNotEmpty)
                BookCoverImage(reference: coverReference!),
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
        borderRadius: coverRadius,
        child: showMetadata
            ? Column(
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
              )
            : cover,
      ),
    );
  }
}
