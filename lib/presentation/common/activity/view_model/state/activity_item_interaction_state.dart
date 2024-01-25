/// The state class for activity item interaction.
class ActivityItemInteractionState {
  final bool displayComments;

  const ActivityItemInteractionState({required this.displayComments});

  /// Factory method to create the initial state.
  factory ActivityItemInteractionState.initial() {
    return const ActivityItemInteractionState(displayComments: false);
  }

  ActivityItemInteractionState copyWith({bool? displayComments}) {
    return ActivityItemInteractionState(
        displayComments: displayComments ?? this.displayComments);
  }
}
