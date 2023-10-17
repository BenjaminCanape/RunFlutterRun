import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:run_flutter_run/data/repositories/friend_request_repository_impl.dart';
import 'package:run_flutter_run/domain/entities/user.dart';

import 'state/pending_requests_state.dart';

/// Provider for the pending request view model.
final pendingRequestsViewModelProvider =
    StateNotifierProvider<PendingRequestsViewModel, PendingRequestsState>(
        (ref) => PendingRequestsViewModel(ref));

/// View model for the pending requests screen.
class PendingRequestsViewModel extends StateNotifier<PendingRequestsState> {
  late final Ref ref;

  PendingRequestsViewModel(this.ref) : super(PendingRequestsState.initial()) {}

  Future<List<User>> getPendingRequests() async {
    //state = state.copyWith(pendingRequests: [], isLoading: true);
    /*return ref
        .read(friendRequestRepositoryProvider)
        .getPendingRequestUsers()
        .then((value) =>
            state = state.copyWith(pendingRequests: value, isLoading: false));*/
    return await ref
        .read(friendRequestRepositoryProvider)
        .getPendingRequestUsers();
  }

  void setPendingRequest(List<User> users) {
    state = state.copyWith(pendingRequests: users);
  }

  acceptRequest(String userId) {
    state = state.copyWith(isLoading: true);
    return ref
        .read(friendRequestRepositoryProvider)
        .accept((userId))
        .then((value) {
      var requests = state.pendingRequests;
      requests.removeWhere((user) => user.id == userId);
      state = state.copyWith(isLoading: false);
    });
  }

  rejectRequest(String userId) {
    state = state.copyWith(isLoading: true);
    return ref
        .read(friendRequestRepositoryProvider)
        .reject((userId))
        .then((value) {
      var requests = state.pendingRequests;
      requests.removeWhere((user) => user.id == userId);
      state = state.copyWith(isLoading: false);
    });
  }
}
