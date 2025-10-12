import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthDataSource {
  Future<String?> signUp(String email, String password);
  Future<String?> signIn(String email, String password);
  Future<void> signOut();
}

class AuthDataSourceImpl extends AuthDataSource {
  final _auth = Supabase.instance.client.auth;

  @override
  Future<String?> signUp(String email, String password) async {
    final res = await _auth.signUp(email: email, password: password);
    return res.user?.id;
  }

  @override
  Future<String?> signIn(String email, String password) async {
    final res = await _auth.signInWithPassword(
      email: email,
      password: password,
    );
    return res.user?.id;
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
