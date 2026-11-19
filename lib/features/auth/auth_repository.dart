class AuthUser {
  const AuthUser({required this.id, this.email});

  final String id;
  final String? email;
}

enum AuthFailureReason {
  invalidCredentials,
  emailNotFound,
  emailAlreadyRegistered,
  network,
  unexpected,
}

class AuthFailure implements Exception {
  const AuthFailure(this.reason);

  final AuthFailureReason reason;

  String get userMessage => switch (reason) {
    AuthFailureReason.invalidCredentials =>
      'Email or password is incorrect. Check your details and try again.',
    AuthFailureReason.emailNotFound =>
      'No account was found with that email address.',
    AuthFailureReason.emailAlreadyRegistered =>
      'An account with this email already exists. Try signing in instead.',
    AuthFailureReason.network =>
      'Could not connect. Check your internet connection and try again.',
    AuthFailureReason.unexpected => 'Something went wrong. Please try again.',
  };
}

abstract class AuthRepository {
  AuthUser? get currentUser;
  Stream<AuthUser?> get authStateChanges;

  Future<void> signIn({required String email, required String password});
  Future<bool> signUp({
    required String displayName,
    required String email,
    required String password,
  });
  Future<void> signOut();
  Future<void> resetPassword(String email);
  Future<bool> isApproved();
}
