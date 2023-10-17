/// Represents the state of metrics.
class MetricsState {
  /// The distance covered.
  final double distance;

  /// The global speed.
  final double globalSpeed;

  /// Creates a new instance of [MetricsState].
  const MetricsState({required this.distance, required this.globalSpeed});

  /// Creates an initial instance of [MetricsState] with default values.
  factory MetricsState.initial() {
    return const MetricsState(distance: 0, globalSpeed: 0);
  }

  /// Creates a copy of [MetricsState] with optional updates.
  MetricsState copyWith({double? distance, double? globalSpeed}) {
    return MetricsState(
      distance: distance ?? this.distance,
      globalSpeed: globalSpeed ?? this.globalSpeed,
    );
  }
}
