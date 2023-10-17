class SettingsState {
  final bool isLoading;

  /// Represents the state of the settings screen.
  ///
  /// [isLoading] indicates whether the screen is in a loading state.
  const SettingsState({
    required this.isLoading,
  });

  /// Creates an initial state for the settings screen.
  factory SettingsState.initial() {
    return const SettingsState(
      isLoading: false,
    );
  }

  /// Creates a copy of this state object with the provided changes.
  SettingsState copyWith({
    bool? isLoading,
  }) {
    return SettingsState(
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
