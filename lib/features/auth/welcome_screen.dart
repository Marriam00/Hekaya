import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_tokens.dart';
import '../shared/widgets/app_buttons.dart';
import 'auth_repository.dart';
import 'auth_repository_scope.dart';
import 'auth_validation.dart';
import 'forgot_password_dialog.dart';
import 'widgets/auth_feedback.dart';
import 'widgets/welcome_components.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _signInFormKey = GlobalKey<FormState>();
  final _requestFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  WelcomeMode _mode = WelcomeMode.signIn;
  bool _obscurePassword = true;
  bool _loading = false;
  String? _error;
  String? _notice;

  GlobalKey<FormState> get _activeFormKey =>
      _mode == WelcomeMode.signIn ? _signInFormKey : _requestFormKey;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _selectMode(WelcomeMode mode) {
    if (_loading || _mode == mode) return;
    setState(() {
      _mode = mode;
      _error = null;
      _notice = null;
    });
  }

  Future<void> _submit() async {
    if (!_activeFormKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
      _notice = null;
    });
    final repository = AuthRepositoryScope.of(context);
    try {
      if (_mode == WelcomeMode.signIn) {
        await repository.signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      } else {
        final hasSession = await repository.signUp(
          displayName: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        if (!hasSession && mounted) {
          setState(
            () => _notice =
                'Check your email to confirm your account, then sign in.',
          );
        }
      }
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

  Future<void> _forgotPassword() async {
    if (_loading) return;
    await showForgotPasswordDialog(context, AuthRepositoryScope.of(context));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRequesting = _mode == WelcomeMode.requestAccess;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.pageMargin,
              AppSpacing.gutter,
              AppSpacing.pageMargin,
              AppSpacing.spaceXl,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                children: [
                  WelcomeBranding(theme: theme),
                  const SizedBox(height: AppSpacing.gutter),
                  Card(
                    color: AppColors.surfaceLow,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.gutter),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          WelcomeModeSelector(
                            selectedMode: _mode,
                            enabled: !_loading,
                            onSelected: _selectMode,
                          ),
                          const SizedBox(height: AppSpacing.gutter),
                          const ApprovalNotice(),
                          const SizedBox(height: AppSpacing.gutter),
                          Form(
                            key: _activeFormKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (isRequesting) ...[
                                  TextFormField(
                                    key: const ValueKey('auth-display-name'),
                                    controller: _nameController,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    autofillHints: const [AutofillHints.name],
                                    decoration: const InputDecoration(
                                      labelText: 'Display name',
                                      prefixIcon: Icon(
                                        Icons.person_outline_rounded,
                                      ),
                                    ),
                                    validator: validateDisplayName,
                                  ),
                                  const SizedBox(
                                    height: AppSpacing.gutterCompact,
                                  ),
                                ],
                                TextFormField(
                                  key: const ValueKey('auth-email'),
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  autocorrect: false,
                                  autofillHints: const [AutofillHints.email],
                                  decoration: const InputDecoration(
                                    labelText: 'Email',
                                    prefixIcon: Icon(
                                      Icons.mail_outline_rounded,
                                    ),
                                  ),
                                  validator: validateAuthEmail,
                                ),
                                const SizedBox(
                                  height: AppSpacing.gutterCompact,
                                ),
                                TextFormField(
                                  key: const ValueKey('auth-password'),
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  autofillHints: isRequesting
                                      ? const [AutofillHints.newPassword]
                                      : const [AutofillHints.password],
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    prefixIcon: const Icon(Icons.key_outlined),
                                    suffixIcon: IconButton(
                                      tooltip: _obscurePassword
                                          ? 'Show password'
                                          : 'Hide password',
                                      onPressed: _loading
                                          ? null
                                          : () => setState(
                                              () => _obscurePassword =
                                                  !_obscurePassword,
                                            ),
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                      ),
                                    ),
                                  ),
                                  validator: (value) => validateAuthPassword(
                                    value,
                                    requireLength: isRequesting,
                                  ),
                                ),
                                if (!isRequesting) ...[
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: _loading
                                          ? null
                                          : _forgotPassword,
                                      child: const Text('Forgot password?'),
                                    ),
                                  ),
                                ] else
                                  const SizedBox(
                                    height: AppSpacing.gutterCompact,
                                  ),
                                AppPrimaryButton(
                                  key: const ValueKey('auth-submit'),
                                  label: isRequesting
                                      ? 'Request Access'
                                      : 'Sign In',
                                  icon: Icons.arrow_forward_rounded,
                                  isLoading: _loading,
                                  onPressed: _submit,
                                ),
                              ],
                            ),
                          ),
                          if (_error != null) ...[
                            const SizedBox(height: AppSpacing.gutterCompact),
                            AuthFeedback(message: _error!, isError: true),
                          ],
                          if (_notice != null) ...[
                            const SizedBox(height: AppSpacing.gutterCompact),
                            AuthFeedback(message: _notice!),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.spaceLg),
                  const WelcomeFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
