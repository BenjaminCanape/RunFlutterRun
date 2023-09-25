import 'package:equatable/equatable.dart';
import 'package:run_flutter_run/domain/entities/enum/friend_request_status.dart';
import 'package:run_flutter_run/domain/entities/friend_request.dart';

/// Represents a response object for a friend request.
class FriendRequestResponse extends Equatable {
  /// The username of the user
  final FriendRequestStatus status;

  /// Constructs an FriendRequestResponse object with the given parameters.
  const FriendRequestResponse({required this.status});

  @override
  List<Object?> get props => [status];

  /// Creates an FriendRequestResponse object from a JSON map.
  factory FriendRequestResponse.fromMap(Map<String, dynamic> map) {
    return FriendRequestResponse(status: map['status']);
  }

  /// Converts the FriendRequestResponse object to a FriendRequest entity.
  FriendRequest toEntity() {
    return FriendRequest(status: status);
  }
}
