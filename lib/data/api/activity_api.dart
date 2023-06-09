import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_run_run/data/api/remote_api.dart';
import 'dart:io';

import 'package:dio/dio.dart';
import '../../core/error.dart';
import '../models/request/ActivityRequest.dart';
import '../models/response/activity.dart';

const String url = 'https://runbackendrun.onrender.com/api/activity/';

final activityApiProvider = Provider<ActivityApi>((ref) => ActivityApi());

class ActivityApi extends RemoteApi {
  ActivityApi() : super(url);

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
