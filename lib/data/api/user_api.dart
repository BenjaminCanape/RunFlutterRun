import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/request/LoginRequest.dart';
import '../models/response/LoginResponse.dart';
import 'remote_api.dart';

final userApiProvider = Provider<UserApi>((ref) => UserApi());

class UserApi {
  UserApi();

  Future<int> createUser(LoginRequest request) async {
    Response? response = await ApiHelper.makeRequest(
        '${ApiHelper.apiUrl}user/register', 'POST',
        data: request.toMap());
    return response?.data;
  }

  Future<LoginResponse> login(LoginRequest request) async {
    Response? response = await ApiHelper.makeRequest(
        '${ApiHelper.apiUrl}user/login', 'POST',
        queryParams: request.toMap());
    return LoginResponse.fromMap(response?.data);
  }

  Future<void> logout() async {
    await ApiHelper.makeRequest(
        '${ApiHelper.apiUrl}private/user/logout', 'POST');
  }

  Future<void> delete() async {
    await ApiHelper.makeRequest('${ApiHelper.apiUrl}private/user', 'DELETE');
  }
}
