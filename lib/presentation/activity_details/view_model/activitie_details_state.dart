import '../../../domain/entities/activity.dart';

/// Represents the state of the activity details screen.
class ActivityDetailsState {
  final Activity? activity;
  final bool isLoading;

  const ActivityDetailsState({this.activity, required this.isLoading});

  /// Creates an initial state with no activity.
  factory ActivityDetailsState.initial() {
    return const ActivityDetailsState(isLoading: false);
  }

  /// Creates a new state with the provided activity, or retains the existing activity if not provided.
  ActivityDetailsState copyWith({Activity? activity, bool? isLoading}) {
    return ActivityDetailsState(
        activity: activity ?? this.activity,
        isLoading: isLoading ?? this.isLoading);
  }
}
