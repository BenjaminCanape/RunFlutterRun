import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'state/activity_list_state.dart';

/// Provider for the activity list view model.
final activityListWidgetViewModelProvider = StateNotifierProvider.family<
    ActivityListWidgetViewModel,
    ActivityListWidgetState,
    String>((ref, listId) => ActivityListWidgetViewModel(ref, listId));

/// View model for the activity item widget.
class ActivityListWidgetViewModel
    extends StateNotifier<ActivityListWidgetState> {
  final Ref ref;
  final String listId;
  final ScrollController scrollController = ScrollController();

  ActivityListWidgetViewModel(this.ref, this.listId)
      : super(ActivityListWidgetState.initial());

  int calculateTotalElements(List<dynamic> listOfLists) {
    int totalElements =
        listOfLists.fold(0, (sum, list) => sum + (list.length as int));

    return totalElements;
  }

  bool hasMoreData(List<dynamic> list, int total) {
    return calculateTotalElements(list) < total;
  }
}
