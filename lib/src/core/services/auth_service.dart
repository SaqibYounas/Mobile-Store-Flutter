import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:e_commerce_flutter/src/core/services/session_service.dart';
import 'package:e_commerce_flutter/src/model/user_model.dart';

/// Wraps Supabase auth + role lookup. The DB trigger
/// `handle_new_auth_user` already inserts a `public.users` row on signup, so
/// the client only needs to read it back to discover the role.
class AuthService {
  AuthService._();

  static final _supabase = Supabase.instance.client;

  static User? get currentAuthUser => _supabase.auth.currentUser;

  static bool get isLoggedIn => currentAuthUser != null;

  /// Sign in and load the user profile + role.
  static Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    final res = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    final authUser = res.user;
    if (authUser == null) {
      throw const AuthException('Invalid credentials');
    }
    return _loadProfile(authUser.id);
  }

  /// Register a new user. Always creates the row with role='user'. Promote
  /// to admin from the Supabase dashboard or via SQL.
  static Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    final res = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {'name': name, 'role': 'user'},
    );
    final authUser = res.user;
    if (authUser == null) {
      throw const AuthException('Sign-up failed');
    }
    // Trigger creates public.users row; upsert here is a safety net for
    // databases without the trigger installed.
    await _supabase.from('users').upsert({
      'id': authUser.id,
      'email': email,
      'name': name,
      'role': 'user',
    }, onConflict: 'id');
    return _loadProfile(authUser.id);
  }

  static Future<void> signOut() async {
    await _supabase.auth.signOut();
    await SessionService.clearSession();
  }

  /// Trigger Supabase to send a password reset email. The user clicks the
  /// link in their inbox; reset itself is completed via [updatePassword]
  /// once they return to the app with an authenticated session.
  static Future<void> sendPasswordReset(String email) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }

  /// Set a new password for the currently signed-in user.
  static Future<void> updatePassword(String newPassword) async {
    await _supabase.auth.updateUser(UserAttributes(password: newPassword));
  }

  /// Request email change. Supabase sends a verification link to the new
  /// address; the email column is only updated after the user confirms.
  /// Once verification completes, the local `users` row is mirrored on
  /// next [currentProfile] call (or via [syncEmailFromAuth]).
  static Future<void> requestEmailChange(String newEmail) async {
    await _supabase.auth.updateUser(UserAttributes(email: newEmail));
  }

  /// After the email-change verification link has been opened, the auth
  /// user's email field is updated. Mirror that value into the public
  /// `users` row so the rest of the app sees the new email immediately.
  static Future<void> syncEmailFromAuth() async {
    final user = currentAuthUser;
    if (user == null || user.email == null) return;
    await _supabase
        .from('users')
        .update({'email': user.email})
        .eq('id', user.id);
    await SessionService.saveUserSession(
      user.id,
      SessionService.userName ?? '',
      user.email!,
      role: SessionService.userRole ?? 'user',
    );
  }

  /// Read the current user's profile + role. Returns null if not logged in.
  static Future<UserModel?> currentProfile() async {
    final id = currentAuthUser?.id;
    if (id == null) return null;
    return _loadProfile(id);
  }

  static Future<UserModel> _loadProfile(String id) async {
    final row = await _supabase
        .from('users')
        .select()
        .eq('id', id)
        .maybeSingle();

    final model = row == null
        ? UserModel(id: id, email: currentAuthUser?.email ?? '')
        : UserModel.fromJson(row);

    await SessionService.saveUserSession(
      model.id,
      model.name,
      model.email,
      role: model.role.wire,
    );
    return model;
  }
}
