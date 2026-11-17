import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/app_typography.dart';
import 'member_avatar.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    this.sectionLabel = 'Home',
    this.showBrand = true,
    this.brandImageUrl,
    this.profileName = 'Reader',
    this.profileImageUrl,
    this.onProfileTap,
  });

  final String sectionLabel;
  final bool showBrand;
  final String? brandImageUrl;
  final String profileName;
  final String? profileImageUrl;
  final VoidCallback? onProfileTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      child: SafeArea(
        bottom: false,
        child: Container(
          height: AppSpacing.headerHeight,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pageMargin,
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppColors.outlineVariant.withValues(alpha: 0.35),
              ),
            ),
          ),
          child: Row(
            children: [
              if (showBrand) ...[
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.primaryFixed,
                    borderRadius: BorderRadius.circular(AppRadii.small),
                  ),
                  child: SizedBox(
                    width: AppSpacing.brandMarkSize,
                    height: AppSpacing.brandMarkSize,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        const Icon(
                          Icons.menu_book_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        if (brandImageUrl != null && brandImageUrl!.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(AppRadii.small),
                            child: Image.network(
                              brandImageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const SizedBox(),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.spaceSm),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hekaya',
                        style: AppTypography.textTheme.headlineSmall?.copyWith(
                          fontSize: 18,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        sectionLabel.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.textTheme.labelSmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else
                Expanded(
                  child: Text(
                    sectionLabel,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.textTheme.headlineMedium,
                  ),
                ),
              if (showBrand && onProfileTap != null) ...[
                const SizedBox(width: AppSpacing.spaceXs),
                IconButton(
                  tooltip: 'Profile',
                  onPressed: onProfileTap,
                  icon: MemberAvatar(
                    name: profileName,
                    imageUrl: profileImageUrl,
                    size: 32,
                  ),
                  constraints: const BoxConstraints.tightFor(
                    width: 44,
                    height: 44,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
