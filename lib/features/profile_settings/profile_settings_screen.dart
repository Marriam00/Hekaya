import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_tokens.dart';
import '../../data/models.dart';
import '../../data/repositories/repository_scope.dart';
import '../shared/widgets/app_filter_chip.dart';
import '../shared/widgets/app_header.dart';
import '../shared/widgets/member_avatar.dart';
import '../shared/widgets/section_heading.dart';

class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({
    super.key,
    required this.onOpenLibrary,
    required this.onOpenBorrowing,
  });

  final VoidCallback onOpenLibrary;
  final VoidCallback onOpenBorrowing;

  @override
  Widget build(BuildContext context) {
    final repositories = RepositoryScope.of(context);
    return ListenableBuilder(
      listenable: repositories.changes,
      builder: (context, _) {
        final profile = repositories.profiles.currentProfile;
        final publicBooks = repositories.books.books
            .where(
              (book) =>
                  book.ownerId == profile.id &&
                  book.visibility == BookVisibility.public,
            )
            .toList();
        final lendingEnabled =
            publicBooks.isNotEmpty &&
            publicBooks.every((book) => book.allowLending);

        return Column(
          children: [
            const AppHeader(
              showBrand: false,
              sectionLabel: 'Profile & Settings',
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pageMargin,
                  AppSpacing.spaceLg,
                  AppSpacing.pageMargin,
                  AppSpacing.spaceXl,
                ),
                children: [
                  Center(
                    child: MemberAvatar(
                      name: profile.displayName,
                      size: AppSpacing.settingsAvatarSize,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.spaceSm),
                  Text(
                    profile.displayName,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  if (profile.bio.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.spaceXs),
                    Text(
                      profile.bio,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: AppColors.onSurfaceVariant),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.spaceSm),
                  Center(
                    child: OutlinedButton(
                      onPressed: () => _editProfile(context, profile),
                      child: const Text('Edit Profile'),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.spaceLg),
                  SectionHeading(title: 'Your Account'),
                  const SizedBox(height: AppSpacing.spaceSm),
                  Card(
                    color: AppColors.surfaceContainer,
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.menu_book_outlined),
                          title: const Text('My Library'),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: onOpenLibrary,
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.swap_horiz_rounded),
                          title: const Text('Borrowing & Lending'),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: onOpenBorrowing,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.spaceLg),
                  SectionHeading(title: 'Book Preferences'),
                  const SizedBox(height: AppSpacing.spaceSm),
                  Card(
                    color: AppColors.surfaceContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.gutter),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Default visibility for new books',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: AppSpacing.spaceSm),
                          Wrap(
                            spacing: AppSpacing.spaceSm,
                            children: [
                              AppFilterChip(
                                label: 'Public',
                                selected:
                                    repositories.books.defaultVisibility ==
                                    BookVisibility.public,
                                paddedTapTarget: true,
                                onSelected: (_) =>
                                    repositories.books.setDefaultVisibility(
                                      BookVisibility.public,
                                    ),
                              ),
                              AppFilterChip(
                                label: 'Private',
                                selected:
                                    repositories.books.defaultVisibility ==
                                    BookVisibility.private,
                                paddedTapTarget: true,
                                onSelected: (_) =>
                                    repositories.books.setDefaultVisibility(
                                      BookVisibility.private,
                                    ),
                              ),
                            ],
                          ),
                          const Divider(height: AppSpacing.spaceLg),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Allow borrowing'),
                            value: lendingEnabled,
                            onChanged: (value) => repositories.books
                                .setPublicBookLending(profile.id, value),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editProfile(BuildContext context, Profile profile) async {
    final updated = await showDialog<Profile>(
      context: context,
      builder: (_) => _EditProfileDialog(profile: profile),
    );
    if (updated != null && context.mounted) {
      await RepositoryScope.of(context).profiles.saveProfile(updated);
    }
  }
}

class _EditProfileDialog extends StatefulWidget {
  const _EditProfileDialog({required this.profile});

  final Profile profile;

  @override
  State<_EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<_EditProfileDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.displayName);
    _bioController = TextEditingController(text: widget.profile.bio);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Profile'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MemberAvatar(
              name: widget.profile.displayName,
              size: AppSpacing.profileAvatarSize,
            ),
            const SizedBox(height: AppSpacing.gutterCompact),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: AppSpacing.gutterCompact),
            TextField(
              controller: _bioController,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Bio'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(
            widget.profile.copyWith(
              displayName: _nameController.text.trim(),
              bio: _bioController.text.trim(),
            ),
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
