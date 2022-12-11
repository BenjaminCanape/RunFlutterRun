import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:run_run_run/presentation/common/textToSpeech/text_to_speech.dart';
import 'package:run_run_run/presentation/location/view_model/location_view_model.dart';
import 'package:run_run_run/presentation/timer/viewmodel/timer_view_model.dart';

import '../../metrics/view_model/metrics_view_model.dart';

final sumUpViewModel = Provider.autoDispose((ref) {
  return SumUpViewModel(ref);
});

class SumUpViewModel {
  late Ref ref;

  SumUpViewModel(this.ref) {
    ref.read(textToSpeechService).say("Résumé de l'activité");
  }

  void save(BuildContext context) {
    ref.read(timerViewModelProvider.notifier).resetTimer();
    ref.read(locationViewModelProvider.notifier).resetSavedPositions();
    ref.read(metricsViewModelProvider.notifier).reset();
    ref.read(locationViewModelProvider.notifier).startGettingLocation();

    Navigator.pop(context);
  }
}
