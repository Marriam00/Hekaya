import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_tokens.dart';
import '../shared/widgets/app_buttons.dart';

class PendingApprovalScreen extends StatelessWidget {
  const PendingApprovalScreen({
    super.key,
    required this.onCheckAgain,
    required this.onSignOut,
  });

  final Future<void> Function() onCheckAgain;
  final Future<void> Function() onSignOut;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.pageMargin),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                color: AppColors.surfaceLow,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.spaceLg),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const _BrandMark(),
                      const SizedBox(height: AppSpacing.gutter),
                      Text(
                        'Your story is beginning',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: AppSpacing.gutterCompact),
                      Text(
                        'Your account is waiting for approval. We’ll open the reading circle once an administrator approves your membership.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.spaceLg),
                      AppPrimaryButton(
                        label: 'Check again',
                        icon: Icons.refresh_rounded,
                        onPressed: () async => onCheckAgain(),
                      ),
                      const SizedBox(height: AppSpacing.spaceSm),
                      AppSecondaryButton(
                        label: 'Sign Out',
                        onPressed: () async => onSignOut(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(AppRadii.panel),
      ),
      child: const Icon(
        Icons.menu_book_rounded,
        size: 38,
        color: AppColors.primary,
      ),
    );
  }
}
