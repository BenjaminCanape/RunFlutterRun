import '../../../../domain/entities/activity.dart';

/// The state class for community screen.
class CommunityState {
  final List<Activity> activities; // List of activities
  final bool isLoading; // Indicates if the list is currently loading
  final int pageNumber;

  const CommunityState(
      {required this.activities,
      required this.isLoading,
      required this.pageNumber});

  /// Factory method to create the initial state.
  factory CommunityState.initial() {
    return const CommunityState(
        activities: [], isLoading: false, pageNumber: 0);
  }

  /// Method to create a copy of the state with updated values.
  CommunityState copyWith(
      {List<Activity>? activities, // Updated list of activities
      bool? isLoading, // Updated loading state
      int? pageNumber}) {
    return CommunityState(
        activities: activities ?? this.activities,
        isLoading: isLoading ?? this.isLoading,
        pageNumber: pageNumber ?? this.pageNumber);
  }
}
