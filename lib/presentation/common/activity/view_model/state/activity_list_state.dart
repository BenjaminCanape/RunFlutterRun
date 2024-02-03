import '../../../../../domain/entities/activity.dart';

/// The state class for activity list.
class ActivityListWidgetState {
  final List<List<Activity>> groupedActivities;

  const ActivityListWidgetState({required this.groupedActivities});

  /// Factory method to create the initial state.
  factory ActivityListWidgetState.initial() {
    return const ActivityListWidgetState(groupedActivities: []);
  }

  ActivityListWidgetState copyWith({List<List<Activity>>? groupedActivities}) {
    return ActivityListWidgetState(
        groupedActivities: groupedActivities ?? this.groupedActivities);
  }
}
