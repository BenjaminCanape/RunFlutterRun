import '../../../../domain/entities/activity.dart';

/// The state class for community screen.
class CommunityState {
  final List<Activity> activities; // List of activities
  final bool isLoading; // Indicates if the list is currently loading

  const CommunityState({required this.activities, required this.isLoading});

  /// Factory method to create the initial state.
  factory CommunityState.initial() {
    return const CommunityState(activities: [], isLoading: false);
  }

  /// Method to create a copy of the state with updated values.
  CommunityState copyWith({
    List<Activity>? activities, // Updated list of activities
    bool? isLoading, // Updated loading state
  }) {
    return CommunityState(
        activities: activities ?? this.activities,
        isLoading: isLoading ?? this.isLoading);
  }
}
