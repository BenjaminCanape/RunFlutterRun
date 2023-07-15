import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../core/utils/storage_utils.dart';

import '../api/user_api.dart';
import '../model/request/send_new_password_request.dart';
import '../model/response/login_response.dart';
import '../../domain/repositories/user_repository.dart';
import '../model/request/login_request.dart';

/// Provider for the UserRepository implementation.
final userRepositoryProvider =
    Provider<UserRepository>((ref) => UserRepositoryImpl());

/// Implementation of the UserRepository.
class UserRepositoryImpl extends UserRepository {
  UserRepositoryImpl();

  @override
  Future<int> register(LoginRequest request) async {
    return UserApi.createUser(request);
  }

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    LoginResponse response = await UserApi.login(request);
    await StorageUtils.setJwt(response.token);
    await StorageUtils.setRefreshToken(response.refreshToken);
    return response;
  }

  @override
  Future<void> logout() async {
    await UserApi.logout();
    await StorageUtils.removeJwt();
    await StorageUtils.removeRefreshToken();
    return;
  }

  @override
  Future<void> delete() async {
    return UserApi.delete();
  }

  @override
  Future<void> sendNewPasswordByMail(SendNewPasswordRequest request) async {
    await UserApi.sendNewPasswordByMail(request);
  }
}
