import 'dart:async';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart' hide AuthUser;

import 'auth_repository.dart';

class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository(this._client);

  final SupabaseClient _client;

  @override
  AuthUser? get currentUser => _mapUser(_client.auth.currentUser);

  @override
  Stream<AuthUser?> get authStateChanges => _client.auth.onAuthStateChange.map(
    (state) => _mapUser(state.session?.user),
  );

  @override
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _client.auth.signInWithPassword(email: email, password: password);
    } catch (error) {
      throw _mapFailure(error);
    }
  }

  @override
  Future<bool> signUp({
    required String displayName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'display_name': displayName.trim()},
      );
      return response.session != null;
    } catch (error) {
      throw _mapFailure(error);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (error) {
      throw _mapFailure(error);
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } catch (error) {
      throw _mapFailure(error);
    }
  }

  @override
  Future<bool> isApproved() async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw const AuthFailure(AuthFailureReason.unexpected);
    }

    try {
      final row = await _client
          .from('profiles')
          .select('is_approved')
          .eq('id', user.id)
          .single();
      final isApproved = row['is_approved'];
      if (isApproved is! bool) {
        throw const AuthFailure(AuthFailureReason.unexpected);
      }
      return isApproved;
    } catch (error) {
      throw _mapFailure(error);
    }
  }

  AuthUser? _mapUser(User? user) =>
      user == null ? null : AuthUser(id: user.id, email: user.email);

  AuthFailure _mapFailure(Object error) {
    if (error is AuthFailure) return error;
    if (error is SocketException ||
        error is TimeoutException ||
        error is AuthRetryableFetchException) {
      return const AuthFailure(AuthFailureReason.network);
    }

    final text = error.toString().toLowerCase();
    if (text.contains('socket') ||
        text.contains('network') ||
        text.contains('connection') ||
        text.contains('clientexception')) {
      return const AuthFailure(AuthFailureReason.network);
    }

    if (error is AuthException) {
      final code = error.code?.toLowerCase();
      if (code == 'email_exists' ||
          code == 'user_already_exists' ||
          text.contains('already registered') ||
          text.contains('already exists')) {
        return const AuthFailure(AuthFailureReason.emailAlreadyRegistered);
      }
      if (code == 'user_not_found') {
        return const AuthFailure(AuthFailureReason.emailNotFound);
      }
      if (code == 'invalid_credentials' ||
          text.contains('invalid login credentials')) {
        return const AuthFailure(AuthFailureReason.invalidCredentials);
      }
    }

    return const AuthFailure(AuthFailureReason.unexpected);
  }
}
