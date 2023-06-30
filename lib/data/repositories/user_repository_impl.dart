import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/utils/jwt_utils.dart';
import '../../core/utils/refresh_token_utils.dart';
import '../api/user_api.dart';
import '../model/response/login_response.dart';
import '../../domain/repositories/user_repository.dart';
import '../model/request/login_request.dart';

final userRepositoryProvider =
    Provider<UserRepository>((ref) => UserRepositoryImpl());

class UserRepositoryImpl extends UserRepository {
  UserRepositoryImpl();

  @override
  Future<int> register(LoginRequest request) async {
    return UserApi.createUser(request);
  }

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    LoginResponse response = await UserApi.login(request);
    await JwtUtils.setJwt(response.token);
    await RefreshTokenUtils.setRefreshToken(response.refreshToken);
    return response;
  }

  @override
  Future<void> logout() async {
    await UserApi.logout();
    await JwtUtils.removeJwt();
    await RefreshTokenUtils.removeRefreshToken();
    return;
  }

  @override
  Future<void> delete() async {
    return UserApi.delete();
  }
}
