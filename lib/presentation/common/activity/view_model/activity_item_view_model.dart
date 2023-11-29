import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:run_flutter_run/data/repositories/activity_repository_impl.dart';
import 'package:run_flutter_run/domain/entities/activity.dart';
import '../../../../data/repositories/user_repository_impl.dart';
import '../../../../main.dart';
import '../../../my_activities/screens/activity_details_screen.dart';
import 'state/activity_item_state.dart';

/// Provider for the activity item view model.
final activityItemViewModelProvider = StateNotifierProvider.family<
    ActivityItemViewModel,
    ActivityItemState,
    String>((ref, activityId) => ActivityItemViewModel(ref, activityId));

/// View model for the activity item widget.
class ActivityItemViewModel extends StateNotifier<ActivityItemState> {
  final String activityId;
  final Ref ref;

  ActivityItemViewModel(this.ref, this.activityId)
      : super(ActivityItemState.initial());

  void setActivity(Activity activity) {
    state = state.copyWith(activity: activity);
  }

  Future<Uint8List?> getProfilePicture(String userId) async {
    return ref.read(userRepositoryProvider).downloadProfilePicture(userId);
  }

  /// Like the activity.
  Future<void> like(Activity activity) async {
    await ref.read(activityRepositoryProvider).like(activity.id);
    setActivity(activity.copy(
        likesCount: activity.likesCount + 1, hasCurrentUserLiked: true));
  }

  /// Dislike the activity.
  Future<void> dislike(Activity activity) async {
    await ref.read(activityRepositoryProvider).dislike(activity.id);
    setActivity(activity.copy(
        likesCount: activity.likesCount - 1, hasCurrentUserLiked: false));
  }

  /// Retrieves the details of an activity.
  Future<Activity> getActivityDetails(Activity activity) async {
    try {
      final activityDetails = await ref
          .read(activityRepositoryProvider)
          .getActivityById(id: activity.id);
      return activityDetails;
    } catch (error) {
      // Handle error
      rethrow;
    }
  }

  /// Navigates to the activity details screen.
  void goToActivity(Activity activityDetails) {
    navigatorKey.currentState?.push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) =>
            SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: ActivityDetailsScreen(activity: activityDetails),
        ),
      ),
    );
  }
}
