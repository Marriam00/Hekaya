import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_tokens.dart';

enum WelcomeMode { signIn, requestAccess }

class WelcomeBranding extends StatelessWidget {
  const WelcomeBranding({required this.theme, super.key});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(AppRadii.panel),
              ),
              child: const Icon(
                Icons.menu_book_rounded,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            Positioned(
              right: -AppSpacing.spaceSm,
              bottom: -AppSpacing.spaceXs,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.spaceSm,
                  vertical: AppSpacing.spaceXs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer,
                  borderRadius: BorderRadius.circular(AppRadii.pill),
                ),
                child: Text(
                  'EST. 2024',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.onSecondaryContainer,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.gutterCompact),
        Text('Hekaya', style: theme.textTheme.displaySmall),
        const SizedBox(height: AppSpacing.spaceXs),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 32, height: 1, color: AppColors.outlineVariant),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.spaceSm,
              ),
              child: Text(
                'Folio No. I',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.primary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            Container(width: 32, height: 1, color: AppColors.outlineVariant),
          ],
        ),
        const SizedBox(height: AppSpacing.spaceSm),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Text(
            '“Every reader has a story, and every book creates another one.”',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }
}

class WelcomeModeSelector extends StatelessWidget {
  const WelcomeModeSelector({
    required this.selectedMode,
    required this.enabled,
    required this.onSelected,
    super.key,
  });

  final WelcomeMode selectedMode;
  final bool enabled;
  final ValueChanged<WelcomeMode> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spaceXs),
      decoration: BoxDecoration(
        color: AppColors.surfaceHighest,
        borderRadius: BorderRadius.circular(AppRadii.control),
      ),
      child: Row(
        children: [
          _ModeButton(
            label: 'Sign In',
            selected: selectedMode == WelcomeMode.signIn,
            onTap: enabled ? () => onSelected(WelcomeMode.signIn) : null,
          ),
          _ModeButton(
            label: 'Request Access',
            selected: selectedMode == WelcomeMode.requestAccess,
            onTap: enabled ? () => onSelected(WelcomeMode.requestAccess) : null,
          ),
        ],
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Semantics(
        selected: selected,
        button: true,
        child: Material(
          color: selected ? AppColors.surfaceLowest : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadii.small),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppRadii.small),
            child: SizedBox(
              height: AppSpacing.controlHeight,
              child: Center(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: selected
                        ? AppColors.primary
                        : AppColors.onSurfaceVariant,
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

class ApprovalNotice extends StatelessWidget {
  const ApprovalNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.gutterCompact),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(AppRadii.control),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lock_clock_rounded,
            color: AppColors.primary,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.spaceSm),
          Expanded(
            child: Text(
              'Hekaya is an intimate reading community. New accounts require membership approval.',
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: AppColors.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}

class WelcomeFooter extends StatelessWidget {
  const WelcomeFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelSmall
        ?.copyWith(color: AppColors.secondary);
    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppSpacing.gutterCompact,
          runSpacing: AppSpacing.spaceXs,
          children: [
            Text('•  ARCHIVAL GRADE', style: style),
            Text('•', style: style?.copyWith(color: AppColors.outlineVariant)),
            Text('•  MEMBER CURATED', style: style),
          ],
        ),
        const SizedBox(height: AppSpacing.spaceSm),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Text(
            'By entering, you commit to respecting physical book loans and thoughtful literary dialogue.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: AppColors.outline),
          ),
        ),
      ],
    );
  }
}
