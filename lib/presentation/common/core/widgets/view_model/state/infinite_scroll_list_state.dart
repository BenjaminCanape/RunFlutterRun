/// The state class for infinite scroll list
class InfiniteScrollListState {
  final List<dynamic> data;
  final bool isLoading;
  final int pageNumber;
  final double position;

  const InfiniteScrollListState(
      {required this.data,
      required this.isLoading,
      required this.pageNumber,
      required this.position});

  /// Factory method to create the initial state.
  factory InfiniteScrollListState.initial() {
    return const InfiniteScrollListState(
        data: [], isLoading: false, pageNumber: 0, position: 0.0);
  }

  InfiniteScrollListState copyWith(
      {List<dynamic>? data,
      bool? isLoading,
      int? pageNumber,
      double? position}) {
    return InfiniteScrollListState(
        data: data ?? this.data,
        isLoading: isLoading ?? this.isLoading,
        pageNumber: pageNumber ?? this.pageNumber,
        position: position ?? this.position);
  }
}
