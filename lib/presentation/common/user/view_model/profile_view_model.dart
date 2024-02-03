import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../domain/entities/activity.dart';
import '../../../../core/utils/storage_utils.dart';

import '../../../../data/repositories/activity_repository_impl.dart';
import '../../../../data/repositories/friend_request_repository_impl.dart';
import '../../../../data/repositories/user_repository_impl.dart';
import '../../../../domain/entities/enum/friend_request_status.dart';
import '../../../../domain/entities/page.dart';
import 'state/profile_state.dart';

/// Provider for the profile view model.
final profileViewModelProvider =
    StateNotifierProvider.family<ProfileViewModel, ProfileState, String>(
        (ref, userId) => ProfileViewModel(ref, userId));

/// View model for the community screen.
class ProfileViewModel extends StateNotifier<ProfileState> {
  late final Ref ref;
  final String userId;

  ProfileViewModel(this.ref, this.userId) : super(ProfileState.initial());

  /// Retrieves the friendship status.
  Future<void> getFriendshipStatus(String userId) async {
    final friendRequestRepository = ref.read(friendRequestRepositoryProvider);
    //final activityRepository = ref.read(activityRepositoryProvider);

    final currentUser = await StorageUtils.getUser();

    if (userId != currentUser?.id) {
      final status = await friendRequestRepository.getStatus(userId);
      state = state.copyWith(status: status);
    } else {
      state = state.copyWith(status: FriendRequestStatus.noDisplay);
    }
/*
    if (state.friendshipStatus != null &&
        state.friendshipStatus == FriendRequestStatus.accepted) {
      final activities = await activityRepository.getUserActivities(userId);
      state =
          state.copyWith(activities: activities.list, total: activities.total);
    } else if (userId == currentUser?.id) {
      final activities = await activityRepository.getActivities();
      state = state.copyWith(activities: activities.list);
    }*/
  }

  Future<EntityPage<Activity>> fetchActivities({int pageNumber = 0}) async {
    try {
      final activityRepository = ref.read(activityRepositoryProvider);

      final currentUser = await StorageUtils.getUser();

      if (userId != currentUser?.id) {
        final activities = await activityRepository.getUserActivities(userId,
            pageNumber: pageNumber);
        return activities;
      }
      return await activityRepository.getActivities(pageNumber: pageNumber);
    } catch (error) {
      return EntityPage(list: List.empty(), total: 0);
    }
  }

  /// Send the friend request
  void sendFriendRequest(String userId) async {
    await ref.read(friendRequestRepositoryProvider).sendRequest(userId);
    state = state.copyWith(status: FriendRequestStatus.pending);
  }

  /// unfollow
  void unfollow(String userId) async {
    await ref.read(friendRequestRepositoryProvider).reject(userId);
    state = state.copyWith(status: FriendRequestStatus.rejected);
  }

  Future<void> getProfilePicture(String userId) async {
    ref
        .read(userRepositoryProvider)
        .downloadProfilePicture(userId)
        .then((value) => state = state.copyWith(profilePicture: value));
  }
}
