import 'dart:ffi';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/error.dart';
import '../models/request/LoginRequest.dart';
import 'remote_api.dart';

const String apiUrl = 'https://runbackendrun.onrender.com/api/';

final userApiProvider = Provider<UserApi>((ref) => UserApi());

class UserApi extends RemoteApi {
  UserApi() : super(apiUrl);

  Future<Int> createUser(LoginRequest request) async {
    try {
      final response =
          await dio.post('${apiUrl}user/register', data: request.toMap());

      if (response.statusCode == 200) {
        if (response.data.isNotEmpty) {
          return response.data;
        }
      }
      throw const Failure(message: 'User not created');
    } on DioError catch (err) {
      throw Failure(
          message: err.response?.statusMessage ?? 'Something went wrong!');
    } on SocketException {
      throw const Failure(message: 'Please check your connection.');
    }
  }

  Future<String> login(LoginRequest request) async {
    try {
      final response = await dio.post('${apiUrl}user/login',
          queryParameters: request.toMap());

      if (response.statusCode == 200) {
        if (response.data.isNotEmpty) {
          return response.data["token"].toString();
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
}
