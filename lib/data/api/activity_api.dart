import 'package:dio/dio.dart';

import '../model/request/activity_request.dart';
import '../model/response/activity_response.dart';
import 'helpers/api_helper.dart';

class ActivityApi {
  static Future<List<ActivityResponse>> getActivities() async {
    Response? response = await ApiHelper.makeRequest(
        '${ApiHelper.apiUrl}private/activity/all', 'GET');
    final data = List<Map<String, dynamic>>.from(response?.data);
    return data.map((e) => ActivityResponse.fromMap(e)).toList();
  }

  static Future<ActivityResponse> getActivityById(String id) async {
    Response? response = await ApiHelper.makeRequest(
        '${ApiHelper.apiUrl}private/activity/$id', 'GET');
    return ActivityResponse.fromMap(response?.data);
  }

  static Future<String?> removeActivity(String id) async {
    Response? response = await ApiHelper.makeRequest(
        '${ApiHelper.apiUrl}private/activity/', 'DELETE',
        queryParams: {'id': int.parse(id)});
    return response?.data?.toString();
  }

  static Future<ActivityResponse?> addActivity(ActivityRequest request) async {
    Response? response = await ApiHelper.makeRequest(
        '${ApiHelper.apiUrl}private/activity/', 'POST',
        data: request.toMap());
    return response != null ? ActivityResponse.fromMap(response.data) : null;
  }

  static Future<ActivityResponse> editActivity(ActivityRequest request) async {
    Response? response = await ApiHelper.makeRequest(
        '${ApiHelper.apiUrl}private/activity/', 'PUT',
        data: request.toMap());
    return ActivityResponse.fromMap(response?.data);
  }
}
