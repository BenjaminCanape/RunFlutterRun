import 'package:dio/dio.dart';

import '../../core/utils/jwt_utils.dart';
import '../../core/utils/refresh_token_utils.dart';
import '../model/request/login_request.dart';
import '../model/response/login_response.dart';
import 'helpers/api_helper.dart';

class UserApi {
  static Future<int> createUser(LoginRequest request) async {
    Response? response = await ApiHelper.makeRequest(
        '${ApiHelper.apiUrl}user/register', 'POST',
        data: request.toMap());
    return response?.data;
  }

  static Future<LoginResponse> login(LoginRequest request) async {
    Response? response = await ApiHelper.makeRequest(
        '${ApiHelper.apiUrl}user/login', 'POST',
        data: request.toMap());

    return LoginResponse.fromMap(response?.data);
  }

  static Future<void> logout() async {
    await ApiHelper.makeRequest(
        '${ApiHelper.apiUrl}private/user/logout', 'POST');
  }

  static Future<void> delete() async {
    await ApiHelper.makeRequest('${ApiHelper.apiUrl}private/user', 'DELETE');
  }

  static Future<String?> refreshToken() async {
    String? refreshToken = await RefreshTokenUtils.getRefreshToken();

    Response? response = await ApiHelper.makeRequest(
        '${ApiHelper.apiUrl}user/refreshToken', 'POST',
        data: {'token': refreshToken});

    String? jwt = response?.data['token'];
    await JwtUtils.setJwt(response?.data['token']);

    return jwt;
  }
}
