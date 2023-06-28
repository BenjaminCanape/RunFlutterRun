import '../../../domain/entities/activity.dart';

class ActivityListState {
  final List<Activity> activities;
  final bool isLoading;

  const ActivityListState({required this.activities, required this.isLoading});

  factory ActivityListState.initial() {
    return const ActivityListState(activities: [], isLoading: false);
  }

  ActivityListState copyWith({
    List<Activity>? activities,
    bool? isLoading,
  }) {
    return ActivityListState(
      activities: activities ?? this.activities,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
