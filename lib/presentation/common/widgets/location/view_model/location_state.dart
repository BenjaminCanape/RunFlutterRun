import 'package:geolocator/geolocator.dart';

import '../../../../../data/models/request/location_request.dart';

class LocationState {
  final Position? currentPosition;
  final Position? lastPosition;
  final List<LocationRequest> savedPositions;

  const LocationState({
    this.currentPosition,
    this.lastPosition,
    required this.savedPositions,
  });

  factory LocationState.initial() {
    return const LocationState(savedPositions: []);
  }

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
