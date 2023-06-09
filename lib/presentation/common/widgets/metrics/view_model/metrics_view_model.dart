import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../main.dart';
import '../../../textToSpeech/text_to_speech.dart';
import '../../location/view_model/location_view_model.dart';
import '../../timer/viewmodel/timer_view_model.dart';
import 'metrics_state.dart';

final metricsViewModelProvider =
    StateNotifierProvider.autoDispose<MetricsViewModel, MetricsState>(
        (ref) => MetricsViewModel(ref));

class MetricsViewModel extends StateNotifier<MetricsState> {
  final Ref ref;

  MetricsViewModel(this.ref) : super(MetricsState.initial());

  Future<void> updateMetrics() async {
    final location = ref.read(locationViewModelProvider);
    final timer = ref.read(timerViewModelProvider.notifier);
    final textToSpeech = ref.read(textToSpeechService);

    int lastDistanceInteger = state.distance.toInt();

    var distance = state.distance +
        distanceInKmBetweenCoordinates(
            location.lastPosition?.latitude,
            location.lastPosition?.longitude,
            location.currentPosition?.latitude,
            location.currentPosition?.longitude);

    var globalSpeed = distance / (timer.getTimerInMs() / 3600000);

    state = state.copyWith(distance: distance, globalSpeed: globalSpeed);

    int newDistanceInteger = state.distance.toInt();
    if (newDistanceInteger != lastDistanceInteger) {
      final l10nConf = await ref.read(myAppProvider).getl10nConf();
      textToSpeech.say("$newDistanceInteger ${l10nConf.kilometers}");
      textToSpeech
          .say("${state.globalSpeed} ${l10nConf.kilometers} ${l10nConf.hours}");
    }
  }

  void reset() {
    state = MetricsState.initial();
  }

  double degreesToRadians(degrees) {
    return degrees * pi / 180;
  }

  double distanceInKmBetweenCoordinates(lat1, lon1, lat2, lon2) {
    var earthRadiusKm = 6371;

    var dLat = degreesToRadians(lat2 - lat1);
    var dLon = degreesToRadians(lon2 - lon1);

    lat1 = degreesToRadians(lat1);
    lat2 = degreesToRadians(lat2);

    var a = sin(dLat / 2) * sin(dLat / 2) +
        sin(dLon / 2) * sin(dLon / 2) * cos(lat1) * cos(lat2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusKm * c;
  }
}
