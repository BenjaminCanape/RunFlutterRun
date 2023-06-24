class SettingsState {
  final bool isLoading;

  const SettingsState({
    required this.isLoading,
  });

  factory SettingsState.initial() {
    return SettingsState(
      isLoading: false,
    );
  }

  SettingsState copyWith({
    bool? isLoading,
  }) {
    return SettingsState(
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
