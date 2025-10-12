// data/datasources/auth_datasource.dart
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthDataSource {
  Future<String?> signUp(String email, String password);
  Future<String?> signIn(String email, String password);
  //Deveulva el userId, que será necesario para crear el registro el Profile
}

class AuthDataSourceImpl extends AuthDataSource {
  @override
  Future<String?> signUp(String email, String password) async {
    AuthResponse response = await Supabase.instance.client.auth.signUp(
      email: email,
      password: password,
    );
    return response.user?.id;
  }

  @override
  Future<String?> signIn(String email, String password) async {
    AuthResponse response = await Supabase.instance.client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response.user?.id;
  }

}
