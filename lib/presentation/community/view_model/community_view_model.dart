import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/repositories/activity_repository_impl.dart';
import '../../../data/repositories/user_repository_impl.dart';
import '../../../domain/entities/activity.dart';
import '../../../domain/entities/user.dart';
import 'state/community_state.dart';

/// Provider for the community view model.
final communityViewModelProvider =
    StateNotifierProvider.autoDispose<CommunityViewModel, CommunityState>(
        (ref) => CommunityViewModel(ref));

/// View model for the community screen.
class CommunityViewModel extends StateNotifier<CommunityState> {
  late final Ref ref;

  CommunityViewModel(this.ref) : super(CommunityState.initial());

  Future<List<User>> search(String text) {
    return ref.read(userRepositoryProvider).search(text);
  }

  Future<List<Activity>> getMyAndMyFriendsActivities() {
    return ref.read(activityRepositoryProvider).getMyAndMyFriendsActivities();
  }
}
