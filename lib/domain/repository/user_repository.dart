import 'dart:ffi';

import 'package:run_flutter_run/data/models/request/LoginRequest.dart';

abstract class UserRepository {
  Future<Int> register(LoginRequest request);
  Future<String> login(LoginRequest request);
}
