import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final _client = Supabase.instance.client;

  Future<AuthResponse> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String role,
  }) {
    return _client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': name, 'phone': phone, 'role': role},
    );
  }

  Future<AuthResponse> signIn(String email, String password) =>
      _client.auth.signInWithPassword(email: email, password: password);

  /// Login with email OR mobile number
  Future<AuthResponse> signInWithIdentifier(
    String identifier,
    String password,
  ) async {
    final input = identifier.trim();

    // Email login
    if (input.contains('@')) {
      return signIn(input, password);
    }

    // Mobile login: find the email linked to this phone, then sign in
    final result = await _client.rpc(
      'get_email_by_phone',
      params: {'p_phone': input},
    );

    if (result == null || (result as String).isEmpty) {
      throw const AuthException('Invalid mobile number or password');
    }

    return signIn(result, password);
  }

  Future<void> signOut() => _client.auth.signOut();

  /// True only if the logged-in user has a row in the Owner table.
  Future<bool> isOwner() async {
    final user = _client.auth.currentUser;
    if (user == null) return false;

    final row = await _client
        .from('Owner')
        .select('Owner_ID')
        .eq('auth_id', user.id)
        .maybeSingle();

    return row != null;
  }

  /// Returns the logged-in owner's name from the Owner table.
  Future<String?> getOwnerName() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    final row = await _client
        .from('Owner')
        .select('Name')
        .eq('auth_id', user.id)
        .maybeSingle();

    return row?['Name'] as String?;
  }

  /// Returns 'Owner' if the logged-in user is in the Owner table, else null.
  /// (Tenant roles will be added when tenant accounts are built.)
  Future<String?> getMyRole() async {
    final owner = await isOwner();
    return owner ? 'Owner' : null;
  }
}
