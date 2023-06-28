import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../main.dart';
import '../../../textToSpeech/text_to_speech.dart';
import '../../location/view_model/location_view_model.dart';
import '../../timer/viewmodel/timer_view_model.dart';
import 'metrics_state.dart';

final metricsViewModelProvider =
    StateNotifierProvider.autoDispose<MetricsViewModel, MetricsState>(
  (ref) => MetricsViewModel(ref.container),
);

class MetricsViewModel extends StateNotifier<MetricsState> {
  final ProviderContainer _container;
  late final TextToSpeech textToSpeech;

  MetricsViewModel(this._container) : super(MetricsState.initial()) {
    textToSpeech = _container.read(textToSpeechService);
  }

  Future<void> updateMetrics() async {
    final location = _container.read(locationViewModelProvider);
    final timer = _container.read(timerViewModelProvider.notifier);

    final lastDistanceInteger = state.distance.toInt();

    final distance = state.distance +
        distanceInKmBetweenCoordinates(
          location.lastPosition?.latitude,
          location.lastPosition?.longitude,
          location.currentPosition?.latitude,
          location.currentPosition?.longitude,
        );

    final globalSpeed = distance / (timer.getTimerInMs() / 3600000);

    state = state.copyWith(distance: distance, globalSpeed: globalSpeed);

    final newDistanceInteger = state.distance.toInt();
    if (newDistanceInteger != lastDistanceInteger) {
      final l10nConf = await _container.read(myAppProvider).getLocalizedConf();
      await textToSpeech.say("$newDistanceInteger ${l10nConf.kilometers}");
      textToSpeech.say(
        "${state.globalSpeed.toStringAsFixed(2)} ${l10nConf.kilometers} ${l10nConf.hours}",
      );
    }
  }

  void reset() {
    state = MetricsState.initial();
  }

  double degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  double distanceInKmBetweenCoordinates(
    double? lat1,
    double? lon1,
    double? lat2,
    double? lon2,
  ) {
    const earthRadiusKm = 6371.0;

    final dLat = degreesToRadians(lat2! - lat1!);
    final dLon = degreesToRadians(lon2! - lon1!);

    lat1 = degreesToRadians(lat1);
    lat2 = degreesToRadians(lat2);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        sin(dLon / 2) * sin(dLon / 2) * cos(lat1) * cos(lat2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusKm * c;
  }
}
