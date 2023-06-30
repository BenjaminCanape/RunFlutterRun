import '../../data/model/request/login_request.dart';
import '../../data/model/response/login_response.dart';

abstract class UserRepository {
  Future<int> register(LoginRequest request);
  Future<LoginResponse> login(LoginRequest request);
  Future<void> logout();
  Future<void> delete();
}
