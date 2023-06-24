import 'dart:ffi';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/repository/user_repository.dart';
import '../api/user_api.dart';
import '../models/request/LoginRequest.dart';

final userRepositoryProvider = Provider<UserRepository>(
    (ref) => UserRepositoryImpl(ref.read(userApiProvider)));

class UserRepositoryImpl extends UserRepository {
  final UserApi _remoteApi;

  UserRepositoryImpl(this._remoteApi);

  @override
  Future<Int> register(LoginRequest request) async {
    return _remoteApi.createUser(request);
  }

  @override
  Future<String> login(LoginRequest request) async {
    return _remoteApi.login(request);
  }

  @override
  Future<void> logout() async {
    return _remoteApi.logout();
  }
}
