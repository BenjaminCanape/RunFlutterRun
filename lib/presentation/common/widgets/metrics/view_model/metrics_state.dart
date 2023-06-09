class MetricsState {
  final double globalSpeed;
  final double distance;

  const MetricsState({required this.distance, required this.globalSpeed});

  factory MetricsState.initial() {
    return const MetricsState(distance: 0, globalSpeed: 0);
  }

  MetricsState copyWith({double? distance, double? globalSpeed}) {
    return MetricsState(
        distance: distance ?? this.distance,
        globalSpeed: globalSpeed ?? this.globalSpeed);
  }
}
