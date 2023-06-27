import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/request/ActivityRequest.dart';
import '../models/response/activity.dart';
import 'remote_api.dart';

final activityApiProvider = Provider<ActivityApi>((ref) => ActivityApi());

class ActivityApi {
  ActivityApi();

  Future<List<ActivityResponse>> getActivities() async {
    Response? response = await ApiHelper.makeRequest(
        '${ApiHelper.apiUrl}private/activity/all', 'GET');
    final data = List<Map<String, dynamic>>.from(response?.data);
    return data.map((e) => ActivityResponse.fromMap(e)).toList();
  }

  Future<ActivityResponse> getActivityById(String id) async {
    Response? response = await ApiHelper.makeRequest(
        '${ApiHelper.apiUrl}private/activity/$id', 'GET');
    return ActivityResponse.fromMap(response?.data);
  }

  Future<String?> removeActivity(String id) async {
    Response? response = await ApiHelper.makeRequest(
        '${ApiHelper.apiUrl}private/activity/', 'DELETE',
        queryParams: {'id': int.parse(id)});
    return response?.data?.toString();
  }

  Future<ActivityResponse> addActivity(ActivityRequest request) async {
    Response? response = await ApiHelper.makeRequest(
        '${ApiHelper.apiUrl}private/activity/', 'POST',
        data: request.toMap());
    return ActivityResponse.fromMap(response?.data);
  }

  Future<ActivityResponse> editActivity(ActivityRequest request) async {
    Response? response = await ApiHelper.makeRequest(
        '${ApiHelper.apiUrl}private/activity/', 'PUT',
        data: request.toMap());
    return ActivityResponse.fromMap(response?.data);
  }
}
