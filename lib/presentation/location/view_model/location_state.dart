import 'package:geolocator/geolocator.dart';

class LocationState {
  final Position? currentPosition;
  final Position? lastPosition;

  const LocationState({this.currentPosition, this.lastPosition});

  factory LocationState.initial() {
    return const LocationState();
  }

  LocationState copyWith({Position? currentPosition, Position? lastPosition}) {
    return LocationState(
        currentPosition: currentPosition ?? this.currentPosition,
        lastPosition: lastPosition ?? this.lastPosition);
  }
}
