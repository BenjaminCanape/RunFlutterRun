import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:run_run_run/data/models/request/ActivityRequest.dart';
import 'package:run_run_run/data/models/request/LocationRequest.dart';
import 'package:run_run_run/data/repository/activity_repository_impl.dart';
import 'package:run_run_run/presentation/common/textToSpeech/text_to_speech.dart';
import 'package:run_run_run/presentation/location/view_model/location_view_model.dart';
import 'package:run_run_run/presentation/sum_up/view_model/sum_up_state.dart';
import 'package:run_run_run/presentation/timer/viewmodel/timer_view_model.dart';

import '../../metrics/view_model/metrics_view_model.dart';

final sumUpViewModel = Provider.autoDispose((ref) {
  return SumUpViewModel(ref);
});

final sumUpViewModelProvider =
    StateNotifierProvider.autoDispose<SumUpViewModel, SumUpState>(
        (ref) => SumUpViewModel(ref));

class SumUpViewModel extends StateNotifier<SumUpState> {
  late Ref ref;

  SumUpViewModel(this.ref) : super(SumUpState.initial()) {
    ref.read(textToSpeechService).say("Résumé de l'activité");
  }

  void save(BuildContext context) {
    state = state.copyWith(isSaving: true);
    var startDatetime = ref.read(timerViewModelProvider).startDatetime;
    var endDatetime = startDatetime.add(Duration(
        hours: ref.read(timerViewModelProvider).hours,
        minutes: ref.read(timerViewModelProvider).minutes,
        seconds: ref.read(timerViewModelProvider).secondes));

    var locations = ref.read(locationViewModelProvider).savedPositions;

    ref
        .read(activityRepositoryProvider)
        .addActivity(ActivityRequest(
            startDatetime: startDatetime,
            endDatetime: endDatetime,
            distance: ref.read(metricsViewModelProvider).distance,
            locations: locations))
        .then((value) {
      ref.read(timerViewModelProvider.notifier).resetTimer();
      ref.read(locationViewModelProvider.notifier).resetSavedPositions();
      ref.read(metricsViewModelProvider.notifier).reset();
      ref.read(locationViewModelProvider.notifier).startGettingLocation();

      state = state.copyWith(isSaving: false);
      Navigator.pop(context);
    });
  }
}
