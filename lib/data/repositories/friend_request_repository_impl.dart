import 'dart:ffi';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../api/friend_request_api.dart';
import '../../domain/entities/enum/friend_request_status.dart';
import '../../domain/repositories/friend_request_repository.dart';

import '../../domain/entities/friend_request.dart';
import '../../domain/entities/user.dart';

/// Provider for the FriendRequestRepository implementation.
final friendRequestRepositoryProvider =
    Provider<FriendRequestRepository>((ref) => FriendRequestRepositoryImpl());

/// Implementation of the FriendRequestRepository.
class FriendRequestRepositoryImpl extends FriendRequestRepository {
  FriendRequestRepositoryImpl();

  @override
  Future<List<User>> getPendingRequestUsers() async {
    final pendingUsersResponses =
        await FriendRequestApi.getPendindRequestUsers();
    return pendingUsersResponses
        .map((response) => response.toEntity())
        .toList();
  }

  @override
  Future<FriendRequestStatus?> getStatus(String userId) async {
    return await FriendRequestApi.getStatus(userId);
  }

  @override
  Future<int> sendRequest(String userId) async {
    return await FriendRequestApi.sendRequest(userId);
  }

  @override
  Future<FriendRequest> accept(String userId) async {
    final response = await FriendRequestApi.accept(userId);
    return response.toEntity();
  }

  @override
  Future<FriendRequest> reject(String userId) async {
    final response = await FriendRequestApi.reject(userId);
    return response.toEntity();
  }

  @override
  Future<FriendRequest> cancel(String userId) async {
    final response = await FriendRequestApi.cancel(userId);
    return response.toEntity();
  }
}
