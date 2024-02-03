import '../../../../domain/entities/activity.dart';

/// The state class for the activity list.
class ActivityListState {
  final List<Activity> activities; // List of activities
  final bool isLoading; // Indicates if the list is currently loading
  final int pageNumber;

  const ActivityListState(
      {required this.activities,
      required this.isLoading,
      required this.pageNumber});

  /// Factory method to create the initial state.
  factory ActivityListState.initial() {
    return const ActivityListState(
        activities: [], isLoading: false, pageNumber: 0);
  }

  /// Method to create a copy of the state with updated values.
  ActivityListState copyWith(
      {List<Activity>? activities, // Updated list of activities
      bool? isLoading, // Updated loading state
      int? pageNumber}) {
    return ActivityListState(
        activities: activities ?? this.activities,
        isLoading: isLoading ?? this.isLoading,
        pageNumber: pageNumber ?? this.pageNumber);
  }
}
