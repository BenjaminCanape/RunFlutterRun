import 'package:equatable/equatable.dart';
import 'package:run_flutter_run/domain/entities/enum/friend_request_status.dart';

/// Represents a friend request.
class FriendRequest extends Equatable {
  /// The status of the friend request.
  final FriendRequestStatus? status;

  /// Constructs a FriendRequets object with the given parameters.
  const FriendRequest({required this.status});

  @override
  List<Object?> get props => [status];
}
