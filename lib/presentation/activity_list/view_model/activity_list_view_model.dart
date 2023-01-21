import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:run_run_run/data/repository/activity_repository_impl.dart';
import 'package:run_run_run/presentation/activity_list/view_model/activitie_list_state.dart';

final activityListViewModelProvider =
    StateNotifierProvider.autoDispose<ActivityListViewModel, ActivityListState>(
        (ref) => ActivityListViewModel(ref));

class ActivityListViewModel extends StateNotifier<ActivityListState> {
  late Ref ref;

  ActivityListViewModel(this.ref) : super(ActivityListState.initial()) {
    ref
        .read(activityRepositoryProvider)
        .getActivities()
        .then((activities) => state = state.copyWith(activities: activities));
  }

  void backToHome(BuildContext context) {
    Navigator.pop(context);
  }
}
