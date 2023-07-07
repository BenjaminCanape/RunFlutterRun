import '../../../domain/entities/activity.dart';

/// The state class for the activity list.
class ActivityListState {
  final List<Activity> activities; // List of activities
  final bool isLoading; // Indicates if the list is currently loading

  const ActivityListState({required this.activities, required this.isLoading});

  /// Factory method to create the initial state.
  factory ActivityListState.initial() {
    return const ActivityListState(activities: [], isLoading: false);
  }

  /// Method to create a copy of the state with updated values.
  ActivityListState copyWith({
    List<Activity>? activities, // Updated list of activities
    bool? isLoading, // Updated loading state
  }) {
    return ActivityListState(
      activities: activities ?? this.activities,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
