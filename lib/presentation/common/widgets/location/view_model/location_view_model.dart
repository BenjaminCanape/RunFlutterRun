import 'dart:async';

import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../data/models/request/location_request.dart';
import '../../metrics/view_model/metrics_view_model.dart';
import '../../timer/viewmodel/timer_view_model.dart';
import 'location_state.dart';

final locationViewModelProvider =
    StateNotifierProvider.autoDispose<LocationViewModel, LocationState>(
  (ref) => LocationViewModel(ref),
);

class LocationViewModel extends StateNotifier<LocationState> {
  final Ref ref;
  final MapController mapController = MapController();
  StreamSubscription<Position>? _positionStream;

  LocationViewModel(this.ref) : super(LocationState.initial());

  Future<void> startGettingLocation() async {
    final metricsProvider = ref.read(metricsViewModelProvider.notifier);

    await Geolocator.requestPermission();
    _positionStream ??=
        Geolocator.getPositionStream().listen((Position position) {
      if (mounted) {
        mapController.move(
          LatLng(position.latitude, position.longitude),
          17,
        );

        final timerProvider = ref.read(timerViewModelProvider.notifier);
        if (timerProvider.isTimerRunning() && timerProvider.hasTimerStarted()) {
          metricsProvider.updateMetrics();

          final positions = List<LocationRequest>.from(state.savedPositions);
          positions.add(
            LocationRequest(
              datetime: DateTime.now(),
              latitude: position.latitude,
              longitude: position.longitude,
            ),
          );
          state = state.copyWith(savedPositions: positions);
        }

        state = state.copyWith(
          currentPosition: position,
          lastPosition: state.currentPosition ?? position,
        );
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
