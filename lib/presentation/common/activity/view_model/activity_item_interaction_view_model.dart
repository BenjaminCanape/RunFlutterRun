import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'state/activity_item_interaction_state.dart';

/// Provider for the activity item interaction view model.
final activityItemInteractionViewModelProvider = StateNotifierProvider.family<
        ActivityItemInteractionViewModel, ActivityItemInteractionState, String>(
    (ref, activityId) => ActivityItemInteractionViewModel(ref, activityId));

/// View model for the activity item interaction widget.
class ActivityItemInteractionViewModel
    extends StateNotifier<ActivityItemInteractionState> {
  final String activityId;
  final Ref ref;

  ActivityItemInteractionViewModel(this.ref, this.activityId)
      : super(ActivityItemInteractionState.initial());

  /// Toggle the comments in the state
  void toggleComments() {
    state = state.copyWith(displayComments: !state.displayComments);
  }
}
