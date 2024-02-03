import 'dart:typed_data';

import '../../../../../domain/entities/enum/friend_request_status.dart';

/// The state class for profile.
class ProfileState {
  final bool isLoading; // Indicates if the list is currently loading
  final FriendRequestStatus? friendshipStatus; //the friend request status
  final Uint8List? profilePicture; // the profile picture

  const ProfileState(
      {required this.isLoading,
      required this.friendshipStatus,
      required this.profilePicture});

  /// Factory method to create the initial state.
  factory ProfileState.initial() {
    return const ProfileState(
        isLoading: false, friendshipStatus: null, profilePicture: null);
  }

  /// Method to create a copy of the state with updated values.
  ProfileState copyWith(
      {bool? isLoading, // Updated loading state
      FriendRequestStatus? status, // Updated friend request status
      Uint8List? profilePicture}) {
    return ProfileState(
        isLoading: isLoading ?? this.isLoading,
        friendshipStatus: status ?? friendshipStatus,
        profilePicture: profilePicture ?? this.profilePicture);
  }
}
