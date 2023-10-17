import 'package:hooks_riverpod/hooks_riverpod.dart';
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
  Future<FriendRequestStatus?> getFriendShipStatus(String userId) async {
    //state = state.copyWith(isLoading: true);
    return ref.read(friendRequestRepositoryProvider).getStatus(userId);
  }

  void setRequestStatus(FriendRequestStatus? status) async {
    state = state.copyWith(status: status);
    // return await ref.read(friendRequestRepositoryProvider).getStatus(userId);
  }
}
