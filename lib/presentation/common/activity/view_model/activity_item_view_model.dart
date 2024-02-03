import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../data/repositories/activity_repository_impl.dart';
import '../../../../domain/entities/activity.dart';
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
  final TextEditingController commentController = TextEditingController();

  ActivityItemViewModel(this.ref, this.activityId)
      : super(ActivityItemState.initial());

  /// Sets the activity in the state
  void setActivity(Activity activity) {
    state = state.copyWith(activity: activity);
  }

  /// Get the profile picture of the user
  Future<Uint8List?> getProfilePicture(String userId) async {
    return ref.read(userRepositoryProvider).downloadProfilePicture(userId);
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
