import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'state/infinite_scroll_list_state.dart';

/// Provider for the infinite scroll list view model.
final infiniteScrollListViewModelProvider = StateNotifierProvider.family<
    InfiniteScrollListViewModel,
    InfiniteScrollListState,
    String>((ref, listId) {
  return InfiniteScrollListViewModel(ref, listId);
});

/// View model for the infinite scroll list interaction widget.
class InfiniteScrollListViewModel
    extends StateNotifier<InfiniteScrollListState> {
  final String listId;
  final Ref ref;
  final ScrollController scrollController = ScrollController();

  InfiniteScrollListViewModel(this.ref, this.listId)
      : super(InfiniteScrollListState.initial());

  /// Set isLoading in the state
  void setIsLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  /// Set data in the state
  void setData(List<dynamic> data, double pos) {
    state = state.copyWith(
        data: data, pageNumber: state.pageNumber + 1, position: pos);
  }

  /// Add data in the state
  void addData(List<dynamic> data, double pos) {
    var currentData = state.data;
    currentData.addAll(data);
    state = state.copyWith(
        data: currentData, pageNumber: state.pageNumber + 1, position: pos);
  }

  /// Set pageNumber in the state
  void setPageNumber(int pageNumber) {
    state = state.copyWith(pageNumber: pageNumber);
  }

  /// Set position in the state
  void setPosition(double position) {
    state = state.copyWith(position: position);
  }
}
