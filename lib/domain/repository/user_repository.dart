import 'dart:ffi';

import '../../data/models/request/LoginRequest.dart';

abstract class UserRepository {
  Future<Int> register(LoginRequest request);
  Future<String> login(LoginRequest request);
  Future<void> logout();
  Future<void> delete();
}
