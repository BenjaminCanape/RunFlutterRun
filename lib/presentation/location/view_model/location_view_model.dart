import 'dart:async';

import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:run_run_run/data/models/request/LocationRequest.dart';
import 'package:run_run_run/presentation/location/view_model/location_state.dart';
import 'package:run_run_run/presentation/metrics/view_model/metrics_view_model.dart';
import 'package:run_run_run/presentation/timer/viewmodel/timer_view_model.dart';

final locationViewModelProvider =
    StateNotifierProvider.autoDispose<LocationViewModel, LocationState>(
        (ref) => LocationViewModel(ref));

class LocationViewModel extends StateNotifier<LocationState> {
  Ref ref;
  MapController? mapController;

  LocationViewModel(this.ref) : super(LocationState.initial()) {
    mapController = MapController();
    startGettingLocation();
  }

  StreamSubscription? _positionStream;

  Future<void> startGettingLocation() async {
    final metricsProvider = ref.read(metricsViewModelProvider.notifier);

    await Geolocator.requestPermission();
    _positionStream = _positionStream ??
        Geolocator.getPositionStream().listen((Position position) {
          state = state.copyWith(
              currentPosition: position,
              lastPosition: state.currentPosition ?? position);

          mapController?.move(
              LatLng(position.latitude, position.longitude), 17);

          if (ref.read(timerViewModelProvider.notifier).isTimerRunning() &&
              ref.read(timerViewModelProvider.notifier).hasTimerStarted()) {
            metricsProvider.updateMetrics();

            List<LocationRequest> positions = List.from(state.savedPositions);
            positions.add(LocationRequest(
                datetime: DateTime.now(),
                latitude: position.latitude,
                longitude: position.longitude));
            state = state.copyWith(savedPositions: positions);
          }
        });
  }

  List<LatLng> savedPositionsLatLng() {
    return state.savedPositions
        .map((position) => LatLng(position.latitude, position.longitude))
        .toList();
  }

  void resetSavedPositions() {
    state = state.copyWith(savedPositions: []);
  }

  void stopLocationStream() {
    _positionStream?.pause();
  }

  void resumeLocationStream() {
    _positionStream?.resume();
  }

  void cancelLocationStream() {
    _positionStream?.cancel();
    _positionStream = null;
  }

  bool isLocationStreamPaused() {
    return _positionStream?.isPaused ?? false;
  }
}
