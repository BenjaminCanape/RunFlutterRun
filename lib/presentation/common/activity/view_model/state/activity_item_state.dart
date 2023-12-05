import '../../../../../domain/entities/activity.dart';

/// The state class for activity item.
class ActivityItemState {
  final Activity? activity;
  final bool displayComments;
  final bool displayPreviousComments;

  const ActivityItemState(
      {this.activity,
      required this.displayComments,
      required this.displayPreviousComments});

  /// Factory method to create the initial state.
  factory ActivityItemState.initial() {
    return const ActivityItemState(
        activity: null, displayComments: false, displayPreviousComments: false);
  }

  ActivityItemState copyWith(
      {Activity? activity,
      bool? displayComments,
      bool? displayPreviousComments}) {
    return ActivityItemState(
        activity: activity ?? this.activity,
        displayComments: displayComments ?? this.displayComments,
        displayPreviousComments:
            displayPreviousComments ?? this.displayPreviousComments);
  }
}
