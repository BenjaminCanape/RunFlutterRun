import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:run_flutter_run/data/model/response/friend_request_response.dart';

import '../model/response/user_response.dart';
import 'helpers/api_helper.dart';

/// API methods for managing friend requests.
class FriendRequestApi {
  static String url = '${ApiHelper.apiUrl}private/friends/';

  /// Retrieves a list of users for whom I have a pending request.
  ///
  /// Returns a list of [UserResponse] objects.
  static Future<List<UserResponse>> getPendindRequestUsers() async {
    Response? response =
        await ApiHelper.makeRequest('${FriendRequestApi.url}pending', 'GET');
    final data = List<Map<String, dynamic>>.from(response?.data);
    return data.map((e) => UserResponse.fromMap(e)).toList();
  }

  /// Retrieves the status of the friend request I have with the user
  ///
  /// Returns an [FriendRequestResponse?] object.
  static Future<FriendRequestResponse?> getStatus(String userId) async {
    Response? response = await ApiHelper.makeRequest(
        '${FriendRequestApi.url}getStatus', 'GET',
        data: {'userId': userId});
    return FriendRequestResponse.fromMap(response?.data);
  }

  /// Send the friend request to the user
  ///
  /// Returns an [Long] id of the friend request.
  static Future<Long> sendRequest(String userId) async {
    Response? response = await ApiHelper.makeRequest(
        '${FriendRequestApi.url}sendRequest', 'POST',
        data: {'receiverId': userId});
    return response?.data;
  }

  /// Accept the friend request of the user
  ///
  /// Returns an [FriendRequestResponse].
  static Future<FriendRequestResponse> accept(String userId) async {
    Response? response = await ApiHelper.makeRequest(
        '${FriendRequestApi.url}acceptRequest', 'POST',
        data: {'userId': userId});
    return FriendRequestResponse.fromMap(response?.data);
  }

  /// Reject the friend request of the user
  ///
  /// Returns an [FriendRequestResponse].
  static Future<FriendRequestResponse> reject(String userId) async {
    Response? response = await ApiHelper.makeRequest(
        '${FriendRequestApi.url}rejectRequest', 'POST',
        data: {'userId': userId});
    return FriendRequestResponse.fromMap(response?.data);
  }

  /// Cancel the friend request of the user
  ///
  /// Returns an [FriendRequestResponse].
  static Future<FriendRequestResponse> cancel(String userId) async {
    Response? response = await ApiHelper.makeRequest(
        '${FriendRequestApi.url}cancelRequest', 'POST',
        data: {'userId': userId});
    return FriendRequestResponse.fromMap(response?.data);
  }
}
