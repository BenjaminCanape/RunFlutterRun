import 'package:run_run_run/domain/entities/activity.dart';

class ActivityListState {
  final List<Activity> activities;

  const ActivityListState({required this.activities});

  factory ActivityListState.initial() {
    return const ActivityListState(activities: []);
  }

  ActivityListState copyWith({List<Activity>? activities}) {
    return ActivityListState(activities: activities ?? this.activities);
  }
}
