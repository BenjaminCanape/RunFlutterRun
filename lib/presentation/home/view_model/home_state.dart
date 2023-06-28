class HomeState {
  final int currentIndex;

  const HomeState({required this.currentIndex});

  factory HomeState.initial() {
    return const HomeState(currentIndex: 0);
  }

  HomeState copyWith({
    int? currentIndex,
  }) {
    return HomeState(
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}
