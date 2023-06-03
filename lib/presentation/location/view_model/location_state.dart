import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:run_run_run/data/models/request/LocationRequest.dart';

class LocationState {
  final Position? currentPosition;
  final Position? lastPosition;
  final List<LocationRequest> savedPositions;

  const LocationState(
      {this.currentPosition, this.lastPosition, required this.savedPositions});

  factory LocationState.initial() {
    return const LocationState(savedPositions: []);
  }

  LocationState copyWith(
      {Position? currentPosition,
      Position? lastPosition,
      List<LocationRequest>? savedPositions}) {
    return LocationState(
        currentPosition: currentPosition ?? this.currentPosition,
        lastPosition: lastPosition ?? this.lastPosition,
        savedPositions: savedPositions ?? this.savedPositions);
  }
}
