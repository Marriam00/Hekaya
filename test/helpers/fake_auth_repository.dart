import 'dart:async';

import 'package:hekaya/features/auth/auth_repository.dart';

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({
    AuthUser? initialUser,
    this.approved = true,
    this.signInFailure,
    this.signUpFailure,
    this.signOutFailure,
    this.resetPasswordFailure,
    this.signUpReturnsSession = false,
  }) : _currentUser = initialUser;

  final StreamController<AuthUser?> _changes =
      StreamController<AuthUser?>.broadcast();
  AuthUser? _currentUser;

  bool approved;
  bool signUpReturnsSession;
  AuthFailure? signInFailure;
  AuthFailure? signUpFailure;
  AuthFailure? signOutFailure;
  AuthFailure? resetPasswordFailure;
  int signInCalls = 0;
  int signUpCalls = 0;
  int approvalReads = 0;
  String? requestedDisplayName;
  String? requestedEmail;
  String? resetEmail;

  @override
  AuthUser? get currentUser => _currentUser;

  @override
  Stream<AuthUser?> get authStateChanges async* {
    yield _currentUser;
    yield* _changes.stream;
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    signInCalls++;
    if (signInFailure != null) throw signInFailure!;
    _currentUser = AuthUser(id: 'fake-user', email: email);
    _changes.add(_currentUser);
  }

  @override
  Future<bool> signUp({
    required String displayName,
    required String email,
    required String password,
  }) async {
    signUpCalls++;
    if (signUpFailure != null) throw signUpFailure!;
    requestedDisplayName = displayName;
    requestedEmail = email;
    if (signUpReturnsSession) {
      _currentUser = AuthUser(id: 'fake-user', email: email);
      _changes.add(_currentUser);
    }
    return signUpReturnsSession;
  }

  @override
  Future<void> signOut() async {
    if (signOutFailure != null) throw signOutFailure!;
    _currentUser = null;
    _changes.add(null);
  }

  @override
  Future<void> resetPassword(String email) async {
    if (resetPasswordFailure != null) throw resetPasswordFailure!;
    resetEmail = email;
  }

  @override
  Future<bool> isApproved() async {
    approvalReads++;
    return approved;
  }

  Future<void> dispose() => _changes.close();
}
