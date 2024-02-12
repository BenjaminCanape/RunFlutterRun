import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/utils/storage_utils.dart';
import '../../../../data/repositories/activity_repository_impl.dart';
import '../../../../domain/entities/activity.dart';
import '../../../../domain/entities/activity_comment.dart';
import '../../../../domain/entities/user.dart';
import '../../core/enums/infinite_scroll_list.enum.dart';
import '../../core/utils/activity_utils.dart';
import '../../core/widgets/view_model/infinite_scroll_list_view_model.dart';
import 'state/activity_item_comments_state.dart';

/// Provider for the activity item interaction view model.
final activityItemCommentsViewModelProvider = StateNotifierProvider.family<
        ActivityItemCommentsViewModel, ActivityItemCommentsState, String>(
    (ref, activityId) => ActivityItemCommentsViewModel(ref, activityId));

/// View model for the activity item interaction widget.
class ActivityItemCommentsViewModel
    extends StateNotifier<ActivityItemCommentsState> {
  final String activityId;
  final Ref ref;
  final TextEditingController commentController = TextEditingController();

  ActivityItemCommentsViewModel(this.ref, this.activityId)
      : super(ActivityItemCommentsState.initial());

  /// Toggle the previous comments in the state
  void togglePreviousComments() {
    state =
        state.copyWith(displayPreviousComments: !state.displayPreviousComments);
  }

  /// Set comments in the state
  void setComments(List<ActivityComment> comments) {
    state = state.copyWith(comments: comments);
  }

  /// Comment the activity.
  Future<void> comment(Activity activity) async {
    state = state.copyWith(isLoading: true);
    ActivityComment? activityComment = await ref
        .read(activityRepositoryProvider)
        .createComment(activity.id, commentController.text);
    List<ActivityComment> updatedComments = List.from(state.comments)
      ..add(activityComment!);
    setComments(updatedComments);
    commentController.text = '';

    List<List<Activity>> activities = ref
        .read(infiniteScrollListViewModelProvider(
          InfiniteScrollListEnum.community.toString(),
        ))
        .data as List<List<Activity>>;

    var updatedActivities = ActivityUtils.replaceActivity(
        activities, activity.copy(comments: updatedComments));

    ref
        .read(infiniteScrollListViewModelProvider(
          InfiniteScrollListEnum.community.toString(),
        ).notifier)
        .replaceData(updatedActivities);
    state = state.copyWith(isLoading: false);
  }

  /// Remove the comment
  Future<void> removeActivityComment(String id, Activity activity) async {
    state = state.copyWith(isLoading: true);

    ref.read(activityRepositoryProvider).removeComment(id: id).then((value) {
      List<ActivityComment> updatedComments = List.from(state.comments);
      updatedComments.removeWhere((comment) => comment.id == id);

      List<List<Activity>> activities = ref
          .read(infiniteScrollListViewModelProvider(
            InfiniteScrollListEnum.community.toString(),
          ))
          .data as List<List<Activity>>;

      var updatedActivities = ActivityUtils.replaceActivity(
          activities, activity.copy(comments: updatedComments));

      ref
          .read(infiniteScrollListViewModelProvider(
            InfiniteScrollListEnum.community.toString(),
          ).notifier)
          .replaceData(updatedActivities);

      state = state.copyWith(comments: updatedComments, isLoading: false);
    }).catchError((error) {
      state = state.copyWith(isLoading: false);
    });
  }

  //get current user
  Future<User?> getCurrentUser() async {
    return await StorageUtils.getUser();
  }
}
