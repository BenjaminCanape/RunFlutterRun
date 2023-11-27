import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../core/utils/storage_utils.dart';
import '../../domain/entities/user.dart';
import '../model/request/edit_password_request.dart';
import '../model/request/edit_profile_request.dart';
import '../model/request/login_request.dart';
import '../model/request/registration_request.dart';
import '../model/request/send_new_password_request.dart';
import '../model/response/login_response.dart';
import '../model/response/user_response.dart';
import 'helpers/api_helper.dart';

/// API methods for managing user-related operations.
class UserApi {
  /// Creates a new user.
  ///
  /// Returns the user ID as an integer.
  static Future<int> createUser(RegistrationRequest request) async {
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
    String? refreshToken = await StorageUtils.getRefreshToken();

    Response? response = await ApiHelper.makeRequest(
        '${ApiHelper.apiUrl}user/refreshToken', 'POST',
        data: {'token': refreshToken});

    String? jwt = response?.data['token'];
    await StorageUtils.setJwt(response?.data['token']);

    return jwt;
  }

  /// Send new password by mail
  ///
  /// Returns a [String].
  static Future<String> sendNewPasswordByMail(
      SendNewPasswordRequest request) async {
    Response? response = await ApiHelper.makeRequest(
        '${ApiHelper.apiUrl}user/sendNewPasswordByMail', 'POST',
        queryParams: request.toMap());

    return response?.data;
  }

  /// Edit password
  ///
  /// Returns a [void] object.
  static Future<void> editPassword(EditPasswordRequest request) async {
    await ApiHelper.makeRequest(
        '${ApiHelper.apiUrl}private/user/editPassword', 'PUT',
        data: request.toMap());
  }

  /// Edit profile
  ///
  /// Returns a [void] object.
  static Future<void> editProfile(EditProfileRequest request) async {
    await ApiHelper.makeRequest(
        '${ApiHelper.apiUrl}private/user/editProfile', 'PUT',
        data: request.toMap());
  }

  /// Search users based on a search value
  ///
  /// Returns a List of [UserResponse] object.
  static Future<List<UserResponse>> search(String text) async {
    Response? response = await ApiHelper.makeRequest(
        '${ApiHelper.apiUrl}private/user/search', 'GET',
        queryParams: {'searchText': text});
    final data = List<Map<String, dynamic>>.from(response?.data);
    return data.map((e) => UserResponse.fromMap(e)).toList();
  }

  /// Download the profile picture of the user id
  ///
  /// Returns a [Uint8List] object.
  static Future<Uint8List?> downloadProfilePicture(String id) async {
    User? user = await StorageUtils.getUser();
    bool useCache = user != null ? user.id == id : false;
    Response? response = await ApiHelper.makeRequest(
        '${ApiHelper.apiUrl}user/picture/download/$id', 'GET',
        noCache: !useCache, responseType: ResponseType.bytes);

    if (response != null &&
        (response.statusCode == 404 || (response.statusCode == 500))) {
      return null;
    }

    if (response != null && response.data != null) {
      try {
        List<int> dataList = [];
        dataList = List<int>.from(response.data);
        Uint8List uint8List = Uint8List.fromList(dataList);
        return uint8List;
      } catch (e) {
        return null;
      }
    }

    return null;
  }

  /// Upload the profile picture of the current user
  static Future<void> uploadProfilePicture(Uint8List file) async {
    MultipartFile multipartFile = MultipartFile.fromBytes(
      file,
      filename: 'profile_picture.jpg',
    );
    await ApiHelper.makeRequest(
        '${ApiHelper.apiUrl}private/user/picture/upload', 'POST_FORM_DATA',
        data: {'file': multipartFile});
    User? user = await StorageUtils.getUser();
    if (user != null) {
      await ApiHelper.removeCacheForUrl(
          '${ApiHelper.apiUrl}user/picture/download/${user.id}');
    }
  }
}
