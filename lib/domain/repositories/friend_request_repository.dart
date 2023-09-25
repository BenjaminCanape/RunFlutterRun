import 'dart:ffi';

import 'package:run_flutter_run/domain/entities/friend_request.dart';

import '../entities/user.dart';

/// Abstract class representing the friend request repository.
abstract class FriendRequestRepository {
  /// Get the users for whom I have a pending friend request
  Future<List<User>> getPendingRequestUsers();

  /// Get the status of the friend request I have with the user
  Future<FriendRequest?> getStatus(String userId);

  /// Send a friend request to the user
  Future<Long> sendRequest(String userId);

  /// Accept the friend request of the user
  Future<FriendRequest> accept(String userId);

  /// Reject the friend request of the user
  Future<FriendRequest> reject(String userId);

  /// Cancel the friend request of the user
  Future<FriendRequest> cancel(String userId);
}
