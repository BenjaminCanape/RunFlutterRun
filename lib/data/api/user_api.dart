import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/error.dart';
import '../models/request/LoginRequest.dart';
import '../models/response/LoginResponse.dart';
import 'remote_api.dart';

const String apiUrl = 'https://runbackendrun.onrender.com/api/';

final userApiProvider = Provider<UserApi>((ref) => UserApi());

class UserApi extends RemoteApi {
  UserApi() : super(apiUrl);

  Future<int> createUser(LoginRequest request) async {
    try {
      final response =
          await dio.post('${apiUrl}user/register', data: request.toMap());

      if (response.statusCode == 200) {
        return response.data;
      }
      throw const Failure(message: 'User not created');
    } on DioError catch (err) {
      throw Failure(
          message: err.response?.statusMessage ?? 'Something went wrong!');
    } on SocketException {
      throw const Failure(message: 'Please check your connection.');
    }
  }

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await dio.post('${apiUrl}user/login',
          queryParameters: request.toMap());

      if (response.statusCode == 200) {
        if (response.data.isNotEmpty) {
          return LoginResponse.fromMap(response.data);
        }
      }
      throw const Failure(message: 'Login failed');
    } on DioError catch (err) {
      throw Failure(
          message: err.response?.statusMessage ?? 'Something went wrong!');
    } on SocketException {
      throw const Failure(message: 'Please check your connection.');
    }
  }

  Future<void> logout() async {
    try {
      await setJwt();
      final response = await dio.post('${apiUrl}private/user/logout');

      if (response.statusCode == 200) {
        return;
      }
      throw const Failure(message: 'Logout failed');
    } on DioError catch (err) {
      if (err.response?.statusCode == 401) {
        Response? response = await handleUnauthorizedError(err, {}, {});
        if (response?.statusCode == 200) {
          return;
        }
      }
      throw Failure(
          message: err.response?.statusMessage ?? 'Something went wrong!');
    } on SocketException {
      throw const Failure(message: 'Please check your connection.');
    }
  }

  Future<void> delete() async {
    try {
      await setJwt();
      final response = await dio.delete('${apiUrl}private/user');

      if (response.statusCode == 200) {
        return;
      }
      throw const Failure(message: 'Delete failed');
    } on DioError catch (err) {
      if (err.response?.statusCode == 401) {
        Response? response = await handleUnauthorizedError(err, {}, {});
        if (response?.statusCode == 200) {
          return;
        }
      }
      throw Failure(
          message: err.response?.statusMessage ?? 'Something went wrong!');
    } on SocketException {
      throw const Failure(message: 'Please check your connection.');
    }
  }
}
