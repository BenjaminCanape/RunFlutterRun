import '../../data/models/request/LoginRequest.dart';
import '../../data/models/response/LoginResponse.dart';

abstract class UserRepository {
  Future<int> register(LoginRequest request);
  Future<LoginResponse> login(LoginRequest request);
  Future<void> logout();
  Future<void> delete();
}
