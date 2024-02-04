import 'package:dio/dio.dart';

import '../model/request/activity_request.dart';
import '../model/response/activity_comment_response.dart';
import '../model/response/activity_response.dart';
import '../model/response/page_response.dart';
import 'helpers/api_helper.dart';

/// API methods for managing activities.
class ActivityApi {
  static String url = '${ApiHelper.apiUrl}private/activity/';

  /// Retrieves a list of activities.
  ///
  /// Returns a list of [ActivityResponse] objects.
  static Future<PageResponse<ActivityResponse>> getActivities(
      int pageNumber) async {
    Response? response = await ApiHelper.makeRequest(
        '${ActivityApi.url}all', 'GET',
        queryParams: {'page': pageNumber, 'size': 5});

    PageResponse pageResponse = PageResponse.fromMap(response?.data);
    final data = List<Map<String, dynamic>>.from(pageResponse.list);
    List<ActivityResponse> activities =
        data.map((e) => ActivityResponse.fromMap(e)).toList();
    return PageResponse(list: activities, total: pageResponse.total);
  }

  /// Retrieves a list of my activities and my friends.
  ///
  /// Returns a list of [ActivityResponse] objects.
  static Future<PageResponse<ActivityResponse>> getMyAndMyFriendsActivities(
      int pageNumber) async {
    Response? response = await ApiHelper.makeRequest(
        '${ActivityApi.url}friends', 'GET',
        queryParams: {'page': pageNumber, 'size': 3}, noCache: true);
    PageResponse pageResponse = PageResponse.fromMap(response?.data);
    final data = List<Map<String, dynamic>>.from(pageResponse.list);
    List<ActivityResponse> activities =
        data.map((e) => ActivityResponse.fromMap(e)).toList();
    return PageResponse(list: activities, total: pageResponse.total);
  }

  /// Retrieves a list of a user activities.
  ///
  /// Returns a list of [ActivityResponse] objects.
  static Future<PageResponse<ActivityResponse>> getUserActivities(
      String userId, int pageNumber) async {
    Response? response = await ApiHelper.makeRequest(
        '${ActivityApi.url}user/$userId', 'GET',
        queryParams: {'page': pageNumber, 'size': 5}, noCache: true);
    PageResponse pageResponse = PageResponse.fromMap(response?.data);
    final data = List<Map<String, dynamic>>.from(pageResponse.list);
    List<ActivityResponse> activities =
        data.map((e) => ActivityResponse.fromMap(e)).toList();
    return PageResponse(list: activities, total: pageResponse.total);
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

  /// Like the activity
  static Future<void> like(String activityId) async {
    await ApiHelper.makeRequest('${ActivityApi.url}like', 'POST_FORM_DATA',
        data: {'id': activityId});
  }

  /// Dislike the activity
  static Future<void> dislike(String activityId) async {
    await ApiHelper.makeRequest('${ActivityApi.url}dislike', 'POST_FORM_DATA',
        data: {'id': activityId});
  }

  /// Comment the activity
  static Future<ActivityCommentResponse> createComment(
      String activityId, String comment) async {
    Response? response = await ApiHelper.makeRequest(
        '${ActivityApi.url}comment', 'POST_FORM_DATA',
        data: {'activityId': activityId, 'comment': comment});
    return ActivityCommentResponse.fromMap(response?.data);
  }

  /// Edits an existing comment.
  ///
  /// Returns an [ActivityCommentResponse] object.
  static Future<ActivityCommentResponse> editComment(
      String id, String comment) async {
    Response? response = await ApiHelper.makeRequest(
        '${ActivityApi.url}comment', 'PUT',
        data: {'id': id, 'comment': comment});
    return ActivityCommentResponse.fromMap(response?.data);
  }

  /// Removes a comment by its ID.
  ///
  /// Returns the response data as a string.
  static Future<String?> removeComment(String id) async {
    Response? response = await ApiHelper.makeRequest(
        '${ActivityApi.url}comment', 'DELETE',
        queryParams: {'id': int.parse(id)});
    return response?.data?.toString();
  }
}
