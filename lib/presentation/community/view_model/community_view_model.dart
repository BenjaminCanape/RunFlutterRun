import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/repositories/activity_repository_impl.dart';
import '../../../data/repositories/user_repository_impl.dart';
import '../../../domain/entities/activity.dart';
import '../../../domain/entities/page.dart';
import '../../../domain/entities/user.dart';
import '../../common/core/enums/infinite_scroll_list.enum.dart';
import '../../common/core/widgets/view_model/infinite_scroll_list_view_model.dart';
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

  Future<EntityPage<Activity>> getInitialMyAndMyFriendsActivities(
      {int pageNumber = 0}) async {
    EntityPage<Activity> newActivities = await ref
        .read(activityRepositoryProvider)
        .getMyAndMyFriendsActivities(pageNumber: pageNumber);
    return newActivities;
  }

  void refreshList() {
    ref
        .read(infiniteScrollListViewModelProvider(
                InfiniteScrollListEnum.community.toString())
            .notifier)
        .reset();
  }
}
