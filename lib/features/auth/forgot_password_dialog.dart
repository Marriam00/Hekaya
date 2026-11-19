import 'package:flutter/material.dart';

import '../../core/theme/app_tokens.dart';
import '../shared/widgets/app_buttons.dart';
import 'auth_repository.dart';
import 'auth_validation.dart';
import 'widgets/auth_feedback.dart';

Future<void> showForgotPasswordDialog(
  BuildContext context,
  AuthRepository repository,
) {
  return showDialog<void>(
    context: context,
    builder: (_) => _ForgotPasswordDialog(repository: repository),
  );
}

class _ForgotPasswordDialog extends StatefulWidget {
  const _ForgotPasswordDialog({required this.repository});

  final AuthRepository repository;

  @override
  State<_ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<_ForgotPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _loading = false;
  bool _sent = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetLink() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await widget.repository.resetPassword(_emailController.text.trim());
      if (mounted) setState(() => _sent = true);
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
    return AlertDialog(
      title: const Text('Reset your password'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_sent)
              const AuthFeedback(
                message: 'If this email exists, a reset link was sent.',
              )
            else ...[
              Text(
                'Enter your email and we’ll send password reset instructions.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.gutter),
              Form(
                key: _formKey,
                child: TextFormField(
                  key: const ValueKey('forgot-password-email'),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: validateAuthEmail,
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: AppSpacing.gutterCompact),
                AuthFeedback(message: _error!, isError: true),
              ],
            ],
          ],
        ),
      ),
      actions: [
        if (!_sent)
          TextButton(
            onPressed: _loading ? null : () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        AppPrimaryButton(
          label: _sent ? 'Done' : 'Send',
          isLoading: _loading,
          onPressed: _sent ? () => Navigator.of(context).pop() : _sendResetLink,
        ),
      ],
    );
  }
}
