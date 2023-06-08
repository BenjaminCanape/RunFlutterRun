import 'dart:ffi';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/error.dart';
import '../models/request/ActivityRequest.dart';
import '../models/response/activity.dart';

final remoteApiProvider = Provider<RemoteApi>((ref) => RemoteApi());

class RemoteApi {
  static const String url = 'https://runbackendrun.onrender.com/api/activity/';
  var dio = Dio();

  RemoteApi() {
    dio.options.connectTimeout = const Duration(seconds: 2);
    dio.interceptors.add(RetryInterceptor(
      dio: dio,
      retries: 5,
      retryDelays: const [
        Duration(seconds: 1),
        Duration(seconds: 2),
        Duration(seconds: 5),
        Duration(seconds: 5),
        Duration(seconds: 10),
      ],
    ));
  }

  Future<List<ActivityResponse>> getActivities() async {
    // Appel WS
    try {
      final response = await dio.get('${url}all');

      // Récupérer réponse
      if (response.statusCode == 200) {
        final data = List<dynamic>.from(response.data);
        if (data.isNotEmpty) {
          return data.map((e) => ActivityResponse.fromMap(e)).toList();
        }
      }
      return [];
    } on DioError catch (err) {
      throw Failure(
          message: err.response?.statusMessage ?? 'Something went wrong!');
    } on SocketException {
      throw const Failure(message: 'Please check your connection.');
    }
  }

  Future<ActivityResponse> getActivityById(String id) async {
    // Appel WS
    try {
      final response = await dio.get(url + id);

      // Récupérer réponse
      if (response.statusCode == 200) {
        if (response.data.isNotEmpty) {
          return ActivityResponse.fromMap(response.data);
        }
      }
      throw const Failure(message: 'Activity not found');
    } on DioError catch (err) {
      throw Failure(
          message: err.response?.statusMessage ?? 'Something went wrong!');
    } on SocketException {
      throw const Failure(message: 'Please check your connection.');
    }
  }

  Future<String> removeActivity(String id) async {
    // Appel WS
    try {
      final response =
          await dio.delete(url, queryParameters: {'id': int.parse(id)});

      // Récupérer réponse
      if (response.statusCode == 200) {
        return response.data;
      }
      throw const Failure(message: 'Remove activity failed');
    } on DioError catch (err) {
      throw Failure(
          message: err.response?.statusMessage ?? 'Something went wrong!');
    } on SocketException {
      throw const Failure(message: 'Please check your connection.');
    }
  }

  Future<ActivityResponse> addActivity(ActivityRequest request) async {
    // Appel WS
    try {
      final response = await dio.post(url, data: request.toMap());

      // Récupérer réponse
      if (response.statusCode == 200) {
        if (response.data.isNotEmpty) {
          return ActivityResponse.fromMap(response.data);
        }
      }
      throw const Failure(message: 'Activity not created');
    } on DioError catch (err) {
      throw Failure(
          message: err.response?.statusMessage ?? 'Something went wrong!');
    } on SocketException {
      throw const Failure(message: 'Please check your connection.');
    }
  }

  Future<ActivityResponse> editActivity(ActivityRequest request) async {
    // Appel WS
    try {
      final response = await dio.put(url, data: request.toMap());

      // Récupérer réponse
      if (response.statusCode == 200) {
        if (response.data.isNotEmpty) {
          return ActivityResponse.fromMap(response.data);
        }
      }
      throw const Failure(message: 'Activity not found');
    } on DioError catch (err) {
      throw Failure(
          message: err.response?.statusMessage ?? 'Something went wrong!');
    } on SocketException {
      throw const Failure(message: 'Please check your connection.');
    }
  }
}
