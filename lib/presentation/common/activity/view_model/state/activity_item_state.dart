import '../../../../../domain/entities/activity.dart';

/// The state class for activity item.
class ActivityItemState {
  final Activity? activity;

  const ActivityItemState({this.activity});

  /// Factory method to create the initial state.
  factory ActivityItemState.initial() {
    return const ActivityItemState(activity: null);
  }

  ActivityItemState copyWith({Activity? activity}) {
    return ActivityItemState(activity: activity ?? this.activity);
  }
}
