import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/utils/storage_utils.dart';
import '../../../../data/repositories/activity_repository_impl.dart';
import '../../../../data/repositories/friend_request_repository_impl.dart';
import '../../../../domain/entities/activity.dart';
import '../../../../domain/entities/enum/friend_request_status.dart';
import '../../../../domain/entities/page.dart';
import '../../core/enums/infinite_scroll_list.enum.dart';
import '../../core/widgets/view_model/infinite_scroll_list_view_model.dart';
import 'profile_picture_view_model.dart';
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
    final currentUser = await StorageUtils.getUser();

    if (userId != currentUser?.id) {
      final status = await friendRequestRepository.getStatus(userId);
      state = state.copyWith(status: status);
    } else {
      state = state.copyWith(status: FriendRequestStatus.noDisplay);
    }
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

  void getProfilePicture(String userId) {
    ref
        .read(profilePictureViewModelProvider(userId).notifier)
        .getProfilePicture(userId);
  }

  void refreshList() {
    ref
        .read(infiniteScrollListViewModelProvider(
          '${InfiniteScrollListEnum.profile}_$userId',
        ).notifier)
        .reset();
  }
}
