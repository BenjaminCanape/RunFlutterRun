/// The state class for the activity list.
class ActivityListState {
  final bool isLoading; // Indicates if the list is currently loading

  const ActivityListState({required this.isLoading});

  /// Factory method to create the initial state.
  factory ActivityListState.initial() {
    return const ActivityListState(isLoading: false);
  }

  /// Method to create a copy of the state with updated values.
  ActivityListState copyWith({
    bool? isLoading, // Updated loading state
  }) {
    return ActivityListState(isLoading: isLoading ?? this.isLoading);
  }
}
