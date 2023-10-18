import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:run_flutter_run/data/repositories/activity_repository_impl.dart';
import 'package:run_flutter_run/data/repositories/friend_request_repository_impl.dart';
import 'package:run_flutter_run/domain/entities/enum/friend_request_status.dart';
import 'state/profile_state.dart';

/// Provider for the profile view model.
final profileViewModelProvider =
    StateNotifierProvider.autoDispose<ProfileViewModel, ProfileState>(
        (ref) => ProfileViewModel(ref));

/// View model for the community screen.
class ProfileViewModel extends StateNotifier<ProfileState> {
  late final Ref ref;

  ProfileViewModel(this.ref) : super(ProfileState.initial());

  /// Retrieves the friendship status.
  Future<void> getFriendshipStatus(String userId) async {
    final friendRequestRepository = ref.read(friendRequestRepositoryProvider);
    final activityRepository = ref.read(activityRepositoryProvider);

    final status = await friendRequestRepository.getStatus(userId);
    state = state.copyWith(status: status);

    if (status != null && status == FriendRequestStatus.accepted) {
      final activities = await activityRepository.getUserActivities(userId);
      state = state.copyWith(activities: activities);
    }
  }

  /// Send the friend request
  void sendFriendRequest(String userId) async {
    await ref.read(friendRequestRepositoryProvider).sendRequest(userId);
    state = state.copyWith(status: FriendRequestStatus.pending);
  }
}
