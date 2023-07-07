import 'package:dio/dio.dart';

import '../../core/utils/jwt_utils.dart';
import '../../core/utils/refresh_token_utils.dart';
import '../model/request/login_request.dart';
import '../model/response/login_response.dart';
import 'helpers/api_helper.dart';

/// API methods for managing user-related operations.
class UserApi {
  /// Creates a new user.
  ///
  /// Returns the user ID as an integer.
  static Future<int> createUser(LoginRequest request) async {
    Response? response = await ApiHelper.makeRequest(
        '${ApiHelper.apiUrl}user/register', 'POST',
        data: request.toMap());
    return response?.data;
  }

  /// Logs in a user.
  ///
  /// Returns a [LoginResponse] object.
  static Future<LoginResponse> login(LoginRequest request) async {
    Response? response = await ApiHelper.makeRequest(
        '${ApiHelper.apiUrl}user/login', 'POST',
        data: request.toMap());

    return LoginResponse.fromMap(response?.data);
  }

  /// Logs out the current user.
  static Future<void> logout() async {
    await ApiHelper.makeRequest(
        '${ApiHelper.apiUrl}private/user/logout', 'POST');
  }

  /// Deletes the current user account.
  static Future<void> delete() async {
    await ApiHelper.makeRequest('${ApiHelper.apiUrl}private/user', 'DELETE');
  }

  /// Refreshes the JWT token using the refresh token.
  ///
  /// Returns the new JWT token as a string.
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
