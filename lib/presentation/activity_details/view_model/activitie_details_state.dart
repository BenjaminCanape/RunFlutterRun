import '../../../domain/entities/activity.dart';

/// Represents the state of the activity details screen.
class ActivityDetailsState {
  final Activity? activity;

  const ActivityDetailsState({this.activity});

  /// Creates an initial state with no activity.
  factory ActivityDetailsState.initial() {
    return const ActivityDetailsState();
  }

  /// Creates a new state with the provided activity, or retains the existing activity if not provided.
  ActivityDetailsState copyWith({Activity? activity}) {
    return ActivityDetailsState(activity: activity ?? this.activity);
  }
}
