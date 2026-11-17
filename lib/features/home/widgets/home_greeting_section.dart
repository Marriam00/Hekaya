import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/models.dart';

class HomeGreetingSection extends StatelessWidget {
  const HomeGreetingSection({
    super.key,
    required this.profile,
    required this.currentBook,
    this.onCurrentBookTap,
  });

  final Profile profile;
  final Book? currentBook;
  final VoidCallback? onCurrentBookTap;

  @override
  Widget build(BuildContext context) {
    final firstName = profile.displayName.split(' ').first;
    final typography = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Good evening,', style: typography.headlineMedium),
        Text(
          firstName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: typography.headlineLarge?.copyWith(color: AppColors.primary),
        ),
        if (currentBook != null) ...[
          const SizedBox(height: AppSpacing.spaceSm),
          Builder(
            builder: (context) {
              final readingLine = Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.spaceXs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.bookmark_outline_rounded,
                    color: AppColors.primary,
                    size: 18,
                  ),
                  const SizedBox(width: AppSpacing.spaceSm),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        style: typography.bodySmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                        children: [
                          const TextSpan(text: 'Currently immersed in '),
                          TextSpan(
                            text: '“${currentBook!.title}”',
                            style: typography.bodySmall?.copyWith(
                              color: AppColors.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              );
              if (onCurrentBookTap == null) return readingLine;
              return InkWell(
                onTap: onCurrentBookTap,
                borderRadius: BorderRadius.circular(AppRadii.small),
                child: readingLine,
              );
            },
          ),
        ],
      ],
    );
  }
}
