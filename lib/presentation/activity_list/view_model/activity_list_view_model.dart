import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/repositories/activity_repository_impl.dart';
import '../../../domain/entities/activity.dart';
import '../../../main.dart';
import '../../activity_details/screen/activity_details_screen.dart';
import 'activity_list_state.dart';

/// The provider for the activity list view model.
final activityListViewModelProvider =
    StateNotifierProvider.autoDispose<ActivityListViewModel, ActivityListState>(
        (ref) => ActivityListViewModel(ref));

/// The view model for the activity list screen.
class ActivityListViewModel extends StateNotifier<ActivityListState> {
  late final Ref ref;

  ActivityListViewModel(this.ref) : super(ActivityListState.initial()) {
    fetchActivities();
  }

  /// Fetches the list of activities.
  Future<void> fetchActivities() async {
    state = state.copyWith(isLoading: true);

    try {
      final activities =
          await ref.read(activityRepositoryProvider).getActivities();
      state = state.copyWith(activities: activities, isLoading: false);
    } catch (error) {
      // Handle error
      state = state.copyWith(isLoading: false);
    }
  }

  /// Retrieves the details of an activity.
  Future<Activity> getActivityDetails(Activity activity) async {
    state = state.copyWith(isLoading: true);

    try {
      final activityDetails = await ref
          .read(activityRepositoryProvider)
          .getActivityById(id: activity.id);
      state = state.copyWith(isLoading: false);
      return activityDetails;
    } catch (error) {
      // Handle error
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  /// Navigates back to the home screen.
  void backToHome() {
    navigatorKey.currentState?.pop();
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

  /// Reload the state with new list of activities
  void reloadActivities(List<Activity> activities) {
    state = state.copyWith(activities: activities);
  }
}
