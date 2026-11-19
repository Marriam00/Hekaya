import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_tokens.dart';
import '../shared/widgets/app_buttons.dart';
import 'auth_repository.dart';
import 'auth_repository_scope.dart';
import 'pending_approval_screen.dart';
import 'welcome_screen.dart';

enum _GateStatus { loading, signedOut, pending, approved, error }

class AuthGate extends StatefulWidget {
  const AuthGate({super.key, required this.app});

  final Widget app;

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  AuthRepository? _repository;
  StreamSubscription<AuthUser?>? _subscription;
  AuthUser? _user;
  _GateStatus _status = _GateStatus.loading;
  int _approvalCheck = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final repository = AuthRepositoryScope.of(context);
    if (identical(repository, _repository)) return;

    _subscription?.cancel();
    _repository = repository;
    _user = repository.currentUser;
    _status = _GateStatus.loading;
    _subscription = repository.authStateChanges.listen(
      _handleAuthChange,
      onError: (Object _) => _handleAuthStreamError(),
    );
    if (_user != null) unawaited(_loadApproval(_user!));
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _handleAuthChange(AuthUser? user) {
    if (!mounted) return;
    if (user == null) {
      _approvalCheck++;
      setState(() {
        _user = null;
        _status = _GateStatus.signedOut;
      });
      return;
    }

    if (_user?.id == user.id && _status != _GateStatus.error) return;
    setState(() {
      _user = user;
      _status = _GateStatus.loading;
    });
    unawaited(_loadApproval(user));
  }

  void _handleAuthStreamError() {
    if (!mounted) return;
    setState(() => _status = _GateStatus.error);
  }

  Future<void> _loadApproval(AuthUser user) async {
    final check = ++_approvalCheck;
    final repository = _repository;
    if (repository == null) return;

    try {
      final approved = await repository.isApproved();
      if (!_isCurrentCheck(check, user)) return;
      setState(
        () => _status = approved ? _GateStatus.approved : _GateStatus.pending,
      );
    } catch (_) {
      if (!_isCurrentCheck(check, user)) return;
      setState(() => _status = _GateStatus.error);
    }
  }

  bool _isCurrentCheck(int check, AuthUser user) =>
      mounted &&
      check == _approvalCheck &&
      _user?.id == user.id &&
      _repository?.currentUser?.id == user.id;

  Future<void> _checkApprovalAgain() async {
    final user = _user;
    if (user == null) return;
    setState(() => _status = _GateStatus.loading);
    await _loadApproval(user);
  }

  Future<void> _signOut() async {
    final repository = _repository;
    if (repository == null) return;
    try {
      await repository.signOut();
    } catch (_) {
      if (mounted) setState(() => _status = _GateStatus.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final page = switch (_status) {
      _GateStatus.loading => const _AuthSplashScreen(),
      _GateStatus.signedOut => const WelcomeScreen(),
      _GateStatus.pending => PendingApprovalScreen(
        onCheckAgain: _checkApprovalAgain,
        onSignOut: _signOut,
      ),
      _GateStatus.approved => null,
      _GateStatus.error => _AuthGateErrorScreen(
        onRetry: _checkApprovalAgain,
        onSignOut: _signOut,
      ),
    };
    if (page == null) return widget.app;

    return Navigator(
      key: ValueKey(_status),
      onGenerateRoute: (_) => MaterialPageRoute<void>(builder: (_) => page),
    );
  }
}

class _AuthSplashScreen extends StatelessWidget {
  const _AuthSplashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
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
            ),
            const SizedBox(height: AppSpacing.gutterCompact),
            Text('Hekaya', style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
    );
  }
}

class _AuthGateErrorScreen extends StatelessWidget {
  const _AuthGateErrorScreen({required this.onRetry, required this.onSignOut});

  final Future<void> Function() onRetry;
  final Future<void> Function() onSignOut;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.pageMargin),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.lock_clock_rounded,
                  size: 40,
                  color: AppColors.primary,
                ),
                const SizedBox(height: AppSpacing.gutter),
                Text(
                  'We couldn’t verify your membership. Check your connection and try again.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.spaceLg),
                AppPrimaryButton(
                  label: 'Try again',
                  onPressed: () async => onRetry(),
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
    );
  }
}
