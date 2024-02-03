import 'dart:typed_data';

import '../../../../../domain/entities/enum/friend_request_status.dart';

import '../../../../../domain/entities/activity.dart';

/// The state class for profile.
class ProfileState {
  final List<Activity> activities; // List of activities
  final int total; // total of activities to display
  final bool isLoading; // Indicates if the list is currently loading
  final FriendRequestStatus? friendshipStatus; //the friend request status
  final Uint8List? profilePicture; // the profile picture

  const ProfileState(
      {required this.activities,
      required this.total,
      required this.isLoading,
      required this.friendshipStatus,
      required this.profilePicture});

  /// Factory method to create the initial state.
  factory ProfileState.initial() {
    return const ProfileState(
        activities: [],
        total: 0,
        isLoading: false,
        friendshipStatus: null,
        profilePicture: null);
  }

  /// Method to create a copy of the state with updated values.
  ProfileState copyWith(
      {List<Activity>? activities, // Updated list of activities
      int? total, // updated total
      bool? isLoading, // Updated loading state
      FriendRequestStatus? status, // Updated friend request status
      Uint8List? profilePicture}) {
    return ProfileState(
        activities: activities ?? this.activities,
        total: total ?? this.total,
        isLoading: isLoading ?? this.isLoading,
        friendshipStatus: status ?? friendshipStatus,
        profilePicture: profilePicture ?? this.profilePicture);
  }
}
