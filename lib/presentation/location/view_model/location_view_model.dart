import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:run_run_run/presentation/location/view_model/location_state.dart';
import 'package:run_run_run/presentation/metrics/view_model/metrics_view_model.dart';

final locationViewModelProvider =
    StateNotifierProvider.autoDispose<LocationViewModel, LocationState>(
        (ref) => LocationViewModel(ref));

class LocationViewModel extends StateNotifier<LocationState> {
  final Ref ref;
  LocationViewModel(this.ref) : super(LocationState.initial());

  StreamSubscription? _positionStream;

  Future<void> startGettingLocation() async {
    final metricsProvider = ref.read(metricsViewModelProvider.notifier);
    await Geolocator.requestPermission();
    _positionStream = _positionStream ??
        Geolocator.getPositionStream().listen((Position position) {
          state = state.copyWith(
              currentPosition: position,
              lastPosition: state.currentPosition ?? position);
          metricsProvider.updateMetrics();
        });
  }

  void stopLocationStream() {
    _positionStream?.pause();
  }

  void resumeLocationStream() {
    _positionStream?.resume();
  }

  void cancelLocationStream() {
    _positionStream?.cancel();
  }

  bool isLocationStreamPaused() {
    return _positionStream?.isPaused ?? false;
  }
}
