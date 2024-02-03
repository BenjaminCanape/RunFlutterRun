import '../../../../domain/entities/user.dart';

/// The state class for pending requests screen.
class PendingRequestsState {
  final bool isLoading;
  final List<User> pendingRequests;
  final int total;

  const PendingRequestsState(
      {required this.isLoading,
      required this.pendingRequests,
      required this.total});

  /// Factory method to create the initial state.
  factory PendingRequestsState.initial() {
    return const PendingRequestsState(
        isLoading: false, pendingRequests: [], total: 0);
  }

  /// Method to create a copy of the state with updated values.
  PendingRequestsState copyWith(
      {bool? isLoading, // Updated loading state
      List<User>? pendingRequests,
      int? total}) {
    return PendingRequestsState(
        isLoading: isLoading ?? this.isLoading,
        pendingRequests: pendingRequests ?? this.pendingRequests,
        total: total ?? this.total);
  }
}
