class HomeState {
  final int currentIndex;

  /// Constructs a `HomeState` object with the provided [currentIndex].
  const HomeState({required this.currentIndex});

  /// Constructs an initial `HomeState` object with the default [currentIndex].
  factory HomeState.initial() {
    return const HomeState(currentIndex: 0);
  }

  /// Creates a copy of this `HomeState` object with the specified attributes overridden.
  HomeState copyWith({
    int? currentIndex,
  }) {
    return HomeState(
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}
