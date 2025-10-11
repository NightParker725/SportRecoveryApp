import 'package:moviles252/domain/model/profile.dart';
import 'package:moviles252/features/auth/data/source/auth_data_source.dart';
import 'package:moviles252/features/auth/domain/repository/auth_repository.dart';
import 'package:moviles252/features/profile/data/source/profile_data_source.dart';

class AuthRepositoryImpl extends AuthRepository {
  AuthDataSource _authDataSource = AuthDataSourceImpl();
  ProfileDataSource _profileDataSource = ProfileDataSourceImpl();

  @override
  Future<void> registerUser(Profile profile, String password) async {
    //1. Registrarnos en el servico de Auth
    String? userId = await _authDataSource.signUp(profile.email, password);
    //2. Crear el Profile
    if (userId != null) {
      profile.id = userId;
      _profileDataSource.createProfile(profile);
    }
  }
}
