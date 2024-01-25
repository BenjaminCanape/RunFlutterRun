import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../data/repositories/activity_repository_impl.dart';
import '../../../../domain/entities/activity.dart';
import 'state/activity_item_like_state.dart';

/// Provider for the activity item like view model.
final activityItemLikeViewModelProvider = StateNotifierProvider.family<
    ActivityItemLikeViewModel,
    ActivityItemLikeState,
    String>((ref, activityId) => ActivityItemLikeViewModel(ref, activityId));

/// View model for the activity item interaction widget.
class ActivityItemLikeViewModel extends StateNotifier<ActivityItemLikeState> {
  final String activityId;
  final Ref ref;

  ActivityItemLikeViewModel(this.ref, this.activityId)
      : super(ActivityItemLikeState.initial());

  /// Set the likes count in the state
  void setLikesCount(double likes) {
    state = state.copyWith(likes: likes);
  }

  /// Set hasUserLiked in the state
  void setHasUserLiked(bool hasUserLiked) {
    state = state.copyWith(hasUserLiked: hasUserLiked);
  }

  /// Like the activity.
  Future<void> like(Activity activity) async {
    await ref.read(activityRepositoryProvider).like(activity.id);
    state = state.copyWith(likes: state.likes + 1, hasUserLiked: true);
  }

  /// Dislike the activity.
  Future<void> dislike(Activity activity) async {
    await ref.read(activityRepositoryProvider).dislike(activity.id);
    state = state.copyWith(likes: state.likes - 1, hasUserLiked: false);
  }
}
