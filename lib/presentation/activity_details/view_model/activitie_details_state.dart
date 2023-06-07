import '../../../domain/entities/activity.dart';

class ActivityDetailsState {
  final Activity? activity;

  const ActivityDetailsState({this.activity});

  factory ActivityDetailsState.initial() {
    return const ActivityDetailsState();
  }

  ActivityDetailsState copyWith({Activity? activity}) {
    return ActivityDetailsState(activity: activity ?? this.activity);
  }
}
