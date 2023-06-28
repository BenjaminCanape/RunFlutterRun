import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/repository/activity_repository_impl.dart';
import '../../../domain/entities/activity.dart';
import '../../../main.dart';
import '../../activity_details/screen/activity_details.dart';
import 'activity_list_state.dart';

final activityListViewModelProvider =
    StateNotifierProvider.autoDispose<ActivityListViewModel, ActivityListState>(
  (ref) => ActivityListViewModel(ref),
);

class ActivityListViewModel extends StateNotifier<ActivityListState> {
  late final Ref ref;

  ActivityListViewModel(this.ref) : super(ActivityListState.initial()) {
    fetchActivities();
  }

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

  void backToHome() {
    navigatorKey.currentState?.pop();
  }

  void goToActivity(Activity activityDetails) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => ActivityDetails(activity: activityDetails),
      ),
    );
  }
}
