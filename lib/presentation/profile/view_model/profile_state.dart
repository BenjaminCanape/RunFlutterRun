import '../../../domain/entities/activity.dart';

/// The state class for profile.
class ProfileState {
  final List<Activity> activities; // List of activities
  final bool isLoading; // Indicates if the list is currently loading

  const ProfileState({required this.activities, required this.isLoading});

  /// Factory method to create the initial state.
  factory ProfileState.initial() {
    return const ProfileState(activities: [], isLoading: false);
  }

  /// Method to create a copy of the state with updated values.
  ProfileState copyWith({
    List<Activity>? activities, // Updated list of activities
    bool? isLoading, // Updated loading state
  }) {
    return ProfileState(
      activities: activities ?? this.activities,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
