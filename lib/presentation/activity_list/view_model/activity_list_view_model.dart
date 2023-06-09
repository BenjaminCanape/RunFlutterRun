import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/repository/activity_repository_impl.dart';
import '../../../domain/entities/activity.dart';
import '../../activity_details/screen/activity_details.dart';
import 'activitie_list_state.dart';

final activityListViewModelProvider =
    StateNotifierProvider.autoDispose<ActivityListViewModel, ActivityListState>(
        (ref) => ActivityListViewModel(ref));

class ActivityListViewModel extends StateNotifier<ActivityListState> {
  late Ref ref;

  ActivityListViewModel(this.ref) : super(ActivityListState.initial()) {
    state = state.copyWith(isLoading: true);
    ref.read(activityRepositoryProvider).getActivities().then((activities) =>
        state = state.copyWith(activities: activities, isLoading: false));
  }

  Future<Activity> getDetails(String id) {
    state = state.copyWith(isLoading: true);
    return ref
        .read(activityRepositoryProvider)
        .getActivityById(id: id)
        .then((activity) {
      state = state.copyWith(isLoading: false);
      return activity;
    });
  }

  Future<Activity> getActivityDetails(Activity activity) async {
    return await getDetails(activity.id);
  }

  void backToHome(BuildContext context) {
    Navigator.pop(context);
  }

  void goToActivity(NavigatorState nav, Activity activityDetails) {
    nav.push(
      MaterialPageRoute(
          builder: (context) => ActivityDetails(activity: activityDetails)),
    );
  }
}
