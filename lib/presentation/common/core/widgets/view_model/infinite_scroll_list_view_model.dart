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

  InfiniteScrollListViewModel(this.ref, this.listId)
      : super(InfiniteScrollListState.initial());

  /// Set isLoading in the state
  void setIsLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  /// Set data in the state
  void setData(List<dynamic> data) {
    state = state.copyWith(data: data, pageNumber: state.pageNumber + 1);
  }

  /// Replace data in the state
  void replaceData(List<dynamic> data) {
    state = state.copyWith(data: data);
  }

  /// Add data in the state
  void addData(List<dynamic> data) {
    var currentData = state.data;
    currentData.addAll(data);
    state = state.copyWith(data: currentData, pageNumber: state.pageNumber + 1);
  }

  /// Set pageNumber in the state
  void setPageNumber(int pageNumber) {
    state = state.copyWith(pageNumber: pageNumber);
  }

  /// reset state
  void reset() {
    state = InfiniteScrollListState.initial();
  }
}
