/// The state class for infinite scroll list
class InfiniteScrollListState {
  final List<dynamic> data;
  final bool isLoading;
  final int pageNumber;

  const InfiniteScrollListState(
      {required this.data, required this.isLoading, required this.pageNumber});

  /// Factory method to create the initial state.
  factory InfiniteScrollListState.initial() {
    return const InfiniteScrollListState(
        data: [], isLoading: false, pageNumber: 0);
  }

  InfiniteScrollListState copyWith(
      {List<dynamic>? data, bool? isLoading, int? pageNumber}) {
    return InfiniteScrollListState(
        data: data ?? this.data,
        isLoading: isLoading ?? this.isLoading,
        pageNumber: pageNumber ?? this.pageNumber);
  }
}
