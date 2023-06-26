import 'package:run_flutter_run/data/models/response/LoginResponse.dart';

import '../../data/models/request/LoginRequest.dart';

abstract class UserRepository {
  Future<int> register(LoginRequest request);
  Future<LoginResponse> login(LoginRequest request);
  Future<void> logout();
  Future<void> delete();
}
