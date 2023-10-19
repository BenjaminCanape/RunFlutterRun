import 'package:dio/dio.dart';

import '../model/request/activity_request.dart';
import '../model/response/activity_response.dart';
import 'helpers/api_helper.dart';

/// API methods for managing activities.
class ActivityApi {
  static String url = '${ApiHelper.apiUrl}private/activity/';

  /// Retrieves a list of activities.
  ///
  /// Returns a list of [ActivityResponse] objects.
  static Future<List<ActivityResponse>> getActivities() async {
    Response? response =
        await ApiHelper.makeRequest('${ActivityApi.url}all', 'GET');
    final data = List<Map<String, dynamic>>.from(response?.data);
    return data.map((e) => ActivityResponse.fromMap(e)).toList();
  }

  /// Retrieves a list of my activities and my friends.
  ///
  /// Returns a list of [ActivityResponse] objects.
  static Future<List<ActivityResponse>> getMyAndMyFriendsActivities() async {
    Response? response = await ApiHelper.makeRequest(
        '${ActivityApi.url}friends', 'GET',
        noCache: true);
    final data = List<Map<String, dynamic>>.from(response?.data);
    return data.map((e) => ActivityResponse.fromMap(e)).toList();
  }

  /// Retrieves a list of a user activities.
  ///
  /// Returns a list of [ActivityResponse] objects.
  static Future<List<ActivityResponse>> getUserActivities(String userId) async {
    Response? response =
        await ApiHelper.makeRequest('${ActivityApi.url}user/$userId', 'GET');
    final data = List<Map<String, dynamic>>.from(response?.data);
    return data.map((e) => ActivityResponse.fromMap(e)).toList();
  }

  /// Retrieves an activity by its ID.
  ///
  /// Returns an [ActivityResponse] object.
  static Future<ActivityResponse> getActivityById(String id) async {
    Response? response =
        await ApiHelper.makeRequest('${ActivityApi.url}$id', 'GET');
    return ActivityResponse.fromMap(response?.data);
  }

  /// Removes an activity by its ID.
  ///
  /// Returns the response data as a string.
  static Future<String?> removeActivity(String id) async {
    Response? response = await ApiHelper.makeRequest(ActivityApi.url, 'DELETE',
        queryParams: {'id': int.parse(id)});
    return response?.data?.toString();
  }

  /// Adds a new activity.
  ///
  /// Returns an [ActivityResponse] object or null if the response is null.
  static Future<ActivityResponse?> addActivity(ActivityRequest request) async {
    Response? response = await ApiHelper.makeRequest(ActivityApi.url, 'POST',
        data: request.toMap());
    return response != null ? ActivityResponse.fromMap(response.data) : null;
  }

  /// Edits an existing activity.
  ///
  /// Returns an [ActivityResponse] object.
  static Future<ActivityResponse> editActivity(ActivityRequest request) async {
    Response? response = await ApiHelper.makeRequest(ActivityApi.url, 'PUT',
        data: request.toMap());
    return ActivityResponse.fromMap(response?.data);
  }
}
