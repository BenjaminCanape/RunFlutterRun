import '../../../../../domain/entities/activity_comment.dart';

/// The state class for activity item comments.
class ActivityItemCommentsState {
  final bool displayPreviousComments;
  final List<ActivityComment> comments;

  const ActivityItemCommentsState(
      {required this.displayPreviousComments, required this.comments});

  /// Factory method to create the initial state.
  factory ActivityItemCommentsState.initial() {
    return const ActivityItemCommentsState(
        displayPreviousComments: false, comments: []);
  }

  ActivityItemCommentsState copyWith(
      {bool? displayPreviousComments, List<ActivityComment>? comments}) {
    return ActivityItemCommentsState(
        displayPreviousComments:
            displayPreviousComments ?? this.displayPreviousComments,
        comments: comments ?? this.comments);
  }
}
