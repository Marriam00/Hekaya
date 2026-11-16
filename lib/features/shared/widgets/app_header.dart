import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/app_typography.dart';
import 'member_avatar.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    this.sectionLabel = 'Home',
    this.profileName = 'Reader',
    this.profileImageUrl,
    this.onNotificationsTap,
    this.onProfileTap,
  });

  final String sectionLabel;
  final String profileName;
  final String? profileImageUrl;
  final VoidCallback? onNotificationsTap;
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
              DecoratedBox(
                decoration: const BoxDecoration(
                  color: AppColors.primaryFixed,
                  shape: BoxShape.circle,
                ),
                child: const SizedBox(
                  width: 36,
                  height: 36,
                  child: Icon(
                    Icons.menu_book_rounded,
                    color: AppColors.primary,
                    size: 21,
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
              IconButton(
                tooltip: 'Notifications',
                onPressed: onNotificationsTap,
                icon: const Icon(Icons.notifications_none_rounded),
                color: AppColors.onSurfaceVariant,
                constraints: const BoxConstraints.tightFor(
                  width: 44,
                  height: 44,
                ),
              ),
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
          ),
        ),
      ),
    );
  }
}
