import 'package:dio/dio.dart';

import '../../domain/entities/enum/friend_request_status.dart';
import '../model/response/friend_request_response.dart';
import '../model/response/page_response.dart';
import '../model/response/user_response.dart';
import 'helpers/api_helper.dart';

/// API methods for managing friend requests.
class FriendRequestApi {
  static String url = '${ApiHelper.apiUrl}private/friends/';

  /// Retrieves a list of users for whom I have a pending request.
  ///
  /// Returns a list of [UserResponse] objects.
  static Future<PageResponse<UserResponse>> getPendindRequestUsers(
      int pageNumber) async {
    Response? response = await ApiHelper.makeRequest(
        '${FriendRequestApi.url}pending', 'GET',
        queryParams: {'page': pageNumber, 'size': 20}, noCache: true);
    PageResponse pageResponse = PageResponse.fromMap(response?.data);
    final data = List<Map<String, dynamic>>.from(pageResponse.list);
    List<UserResponse> users =
        data.map((e) => UserResponse.fromMap(e)).toList();
    return PageResponse(list: users, total: pageResponse.total);
  }

  /// Retrieves the status of the friend request I have with the user
  ///
  /// Returns an [FriendRequestResponse?] object.
  static Future<FriendRequestStatus?> getStatus(String userId) async {
    Response? response = await ApiHelper.makeRequest(
        '${FriendRequestApi.url}getStatus', 'GET',
        queryParams: {'userId': userId}, noCache: true);
    final data = response?.data;
    return data != null
        ? FriendRequestResponse.fromMap(response?.data).status
        : null;
  }

  /// Send the friend request to the user
  ///
  /// Returns an [int] id of the friend request.
  static Future<int> sendRequest(String userId) async {
    Response? response = await ApiHelper.makeRequest(
        '${FriendRequestApi.url}sendRequest', 'POST_FORM_DATA',
        data: {'receiverId': userId});
    return response?.data;
  }

  /// Accept the friend request of the user
  ///
  /// Returns an [FriendRequestResponse].
  static Future<FriendRequestResponse> accept(String userId) async {
    Response? response = await ApiHelper.makeRequest(
        '${FriendRequestApi.url}acceptRequest', 'POST_FORM_DATA',
        data: {'userId': userId});
    return FriendRequestResponse.fromMap(response?.data);
  }

  /// Reject the friend request of the user
  ///
  /// Returns an [FriendRequestResponse].
  static Future<FriendRequestResponse> reject(String userId) async {
    Response? response = await ApiHelper.makeRequest(
        '${FriendRequestApi.url}rejectRequest', 'POST_FORM_DATA',
        data: {'userId': userId});
    return FriendRequestResponse.fromMap(response?.data);
  }

  /// Cancel the friend request of the user
  ///
  /// Returns an [FriendRequestResponse].
  static Future<FriendRequestResponse> cancel(String userId) async {
    Response? response = await ApiHelper.makeRequest(
        '${FriendRequestApi.url}cancelRequest', 'POST_FORM_DATA',
        data: {'userId': userId});
    return FriendRequestResponse.fromMap(response?.data);
  }
}
