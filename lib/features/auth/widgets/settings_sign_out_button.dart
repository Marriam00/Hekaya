import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../auth_repository.dart';
import '../auth_repository_scope.dart';
import '../../shared/widgets/app_buttons.dart';
import '../widgets/auth_feedback.dart';

class SettingsSignOutButton extends StatefulWidget {
  const SettingsSignOutButton({super.key});

  @override
  State<SettingsSignOutButton> createState() => _SettingsSignOutButtonState();
}

class _SettingsSignOutButtonState extends State<SettingsSignOutButton> {
  bool _loading = false;
  String? _error;

  Future<void> _confirmSignOut() async {
    if (_loading) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text('You can sign in again whenever you return.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            key: const ValueKey('confirm-sign-out'),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await AuthRepositoryScope.of(context).signOut();
    } on AuthFailure catch (failure) {
      if (mounted) setState(() => _error = failure.userMessage);
    } catch (_) {
      if (mounted) {
        setState(
          () =>
              _error = const AuthFailure(AuthFailureReason.unexpected)
                  .userMessage,
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSecondaryButton(
          label: _loading ? 'Signing out…' : 'Sign Out',
          onPressed: _loading ? null : _confirmSignOut,
        ),
        if (_error != null) ...[
          const SizedBox(height: AppSpacing.gutterCompact),
          AuthFeedback(message: _error!, isError: true),
        ],
      ],
    );
  }
}
