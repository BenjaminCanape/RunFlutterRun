import 'package:geolocator/geolocator.dart';

import '../../../../../../data/model/request/location_request.dart';

/// Represents the state of the location.
class LocationState {
  /// The current position.
  final Position? currentPosition;

  /// The last recorded position.
  final Position? lastPosition;

  /// The list of saved positions.
  final List<LocationRequest> savedPositions;

  /// Creates a [LocationState] instance.
  ///
  /// The [currentPosition] is the current position.
  /// The [lastPosition] is the last recorded position.
  /// The [savedPositions] is the list of saved positions.
  const LocationState({
    this.currentPosition,
    this.lastPosition,
    required this.savedPositions,
  });

  /// Creates an initial [LocationState] instance.
  factory LocationState.initial() {
    return const LocationState(savedPositions: []);
  }

  /// Creates a copy of this [LocationState] instance with the given fields replaced with the new values.
  LocationState copyWith({
    Position? currentPosition,
    Position? lastPosition,
    List<LocationRequest>? savedPositions,
  }) {
    return LocationState(
      currentPosition: currentPosition ?? this.currentPosition,
      lastPosition: lastPosition ?? this.lastPosition,
      savedPositions: savedPositions ?? this.savedPositions,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationState &&
          runtimeType == other.runtimeType &&
          currentPosition == other.currentPosition &&
          lastPosition == other.lastPosition &&
          savedPositions == other.savedPositions;

  @override
  int get hashCode =>
      currentPosition.hashCode ^
      lastPosition.hashCode ^
      savedPositions.hashCode;
}
