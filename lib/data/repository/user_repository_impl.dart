import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/response/login_response.dart';
import '../../domain/repository/user_repository.dart';
import '../api/user_api.dart';
import '../models/request/login_request.dart';

final userRepositoryProvider = Provider<UserRepository>(
    (ref) => UserRepositoryImpl(ref.read(userApiProvider)));

class UserRepositoryImpl extends UserRepository {
  final UserApi _remoteApi;

  UserRepositoryImpl(this._remoteApi);

  @override
  Future<int> register(LoginRequest request) async {
    return _remoteApi.createUser(request);
  }

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    return _remoteApi.login(request);
  }

  @override
  Future<void> logout() async {
    return _remoteApi.logout();
  }

  @override
  Future<void> delete() async {
    return _remoteApi.delete();
  }
}
