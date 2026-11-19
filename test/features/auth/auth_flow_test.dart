import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hekaya/features/auth/auth_repository.dart';
import 'package:hekaya/features/auth/welcome_screen.dart';
import 'package:hekaya/shell/app_shell.dart';

import '../../helpers/auth_test_app.dart';
import '../../helpers/fake_auth_repository.dart';

void main() {
  testWidgets('successful sign in opens the app shell', (tester) async {
    _setPhoneViewport(tester);
    final auth = FakeAuthRepository(approved: true);
    addTearDown(auth.dispose);
    await tester.pumpWidget(authTestApp(authRepository: auth));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey('auth-email')),
      'reader@example.com',
    );
    await tester.enterText(
      find.byKey(const ValueKey('auth-password')),
      'secret1',
    );
    await tester.tap(find.byKey(const ValueKey('auth-submit')));
    await tester.pumpAndSettle();

    expect(find.byType(AppShell), findsOneWidget);
    expect(auth.signInCalls, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('wrong password shows a friendly message', (tester) async {
    _setPhoneViewport(tester);
    final auth = FakeAuthRepository(
      signInFailure: const AuthFailure(AuthFailureReason.invalidCredentials),
    );
    addTearDown(auth.dispose);
    await tester.pumpWidget(authTestApp(authRepository: auth));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey('auth-email')),
      'reader@example.com',
    );
    await tester.enterText(
      find.byKey(const ValueKey('auth-password')),
      'wrongpass',
    );
    await tester.tap(find.byKey(const ValueKey('auth-submit')));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Email or password is incorrect. Check your details and try again.',
      ),
      findsOneWidget,
    );
    expect(find.textContaining('AuthFailure'), findsNothing);
  });

  testWidgets('request access validates name, email and password', (
    tester,
  ) async {
    _setPhoneViewport(tester);
    final auth = FakeAuthRepository();
    addTearDown(auth.dispose);
    await tester.pumpWidget(authTestApp(authRepository: auth));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Request Access').first);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('auth-submit')));
    await tester.pumpAndSettle();

    expect(find.text('Display name is required.'), findsOneWidget);
    expect(find.text('Email is required.'), findsOneWidget);
    expect(find.text('Password is required.'), findsOneWidget);
    expect(auth.signUpCalls, 0);

    await tester.enterText(
      find.byKey(const ValueKey('auth-display-name')),
      'Layla',
    );
    await tester.enterText(
      find.byKey(const ValueKey('auth-email')),
      'not-an-email',
    );
    await tester.enterText(
      find.byKey(const ValueKey('auth-password')),
      '12345',
    );
    await tester.ensureVisible(find.byKey(const ValueKey('auth-submit')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('auth-submit')));
    await tester.pumpAndSettle();
    expect(find.text('Enter a valid email address.'), findsOneWidget);
    expect(
      find.text('Password must be at least 6 characters.'),
      findsOneWidget,
    );
    expect(auth.signUpCalls, 0);
  });

  testWidgets(
    'sign-up without a session prompts confirmation; session waits for approval',
    (tester) async {
      _setPhoneViewport(tester);
      final auth = FakeAuthRepository(approved: false);
      addTearDown(auth.dispose);
      await tester.pumpWidget(authTestApp(authRepository: auth));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Request Access').first);
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('auth-display-name')),
        'Layla',
      );
      await tester.enterText(
        find.byKey(const ValueKey('auth-email')),
        'reader@example.com',
      );
      await tester.enterText(
        find.byKey(const ValueKey('auth-password')),
        'secret1',
      );
      await tester.tap(find.byKey(const ValueKey('auth-submit')));
      await tester.pumpAndSettle();

      expect(
        find.text('Check your email to confirm your account, then sign in.'),
        findsOneWidget,
      );
      expect(auth.requestedDisplayName, 'Layla');

      auth.signUpReturnsSession = true;
      await tester.tap(find.byKey(const ValueKey('auth-submit')));
      await tester.pumpAndSettle();
      expect(find.text('Your story is beginning'), findsOneWidget);
    },
  );

  testWidgets('forgot password shows the privacy-safe confirmation', (
    tester,
  ) async {
    _setPhoneViewport(tester);
    final auth = FakeAuthRepository();
    addTearDown(auth.dispose);
    await tester.pumpWidget(authTestApp(authRepository: auth));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Forgot password?'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('forgot-password-email')),
      'reader@example.com',
    );
    await tester.tap(find.text('Send'));
    await tester.pumpAndSettle();

    expect(
      find.text('If this email exists, a reset link was sent.'),
      findsOneWidget,
    );
    expect(auth.resetEmail, 'reader@example.com');
  });

  testWidgets('gate shows pending approval for an unapproved account', (
    tester,
  ) async {
    _setPhoneViewport(tester);
    final auth = FakeAuthRepository(
      initialUser: const AuthUser(id: 'waiting-user'),
      approved: false,
    );
    addTearDown(auth.dispose);
    await tester.pumpWidget(authTestApp(authRepository: auth));
    await tester.pumpAndSettle();

    expect(find.text('Your story is beginning'), findsOneWidget);
    expect(find.textContaining('waiting for approval'), findsOneWidget);

    await tester.tap(find.text('Check again'));
    await tester.pumpAndSettle();
    expect(auth.approvalReads, greaterThanOrEqualTo(2));
    expect(find.text('Your story is beginning'), findsOneWidget);
  });

  testWidgets('settings sign out returns the gate to Welcome', (tester) async {
    _setPhoneViewport(tester);
    final auth = FakeAuthRepository(
      initialUser: const AuthUser(id: 'approved-user'),
      approved: true,
    );
    addTearDown(auth.dispose);
    await tester.pumpWidget(authTestApp(authRepository: auth));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Profile'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Sign Out'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign Out'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('confirm-sign-out')));
    await tester.pumpAndSettle();

    expect(find.byType(WelcomeScreen), findsOneWidget);
    expect(find.text('Sign In'), findsWidgets);
    expect(auth.currentUser, isNull);
    expect(tester.takeException(), isNull);
  });
}

void _setPhoneViewport(WidgetTester tester) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(360, 800);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}
