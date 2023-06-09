import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/models/request/ActivityRequest.dart';
import '../../../data/repository/activity_repository_impl.dart';
import '../../common/textToSpeech/text_to_speech.dart';
import '../../common/widgets/location/view_model/location_view_model.dart';
import '../../common/widgets/metrics/view_model/metrics_view_model.dart';
import '../../common/widgets/timer/viewmodel/timer_view_model.dart';
import 'sum_up_state.dart';

final sumUpViewModel = Provider.autoDispose((ref) {
  return SumUpViewModel(ref);
});

final sumUpViewModelProvider =
    StateNotifierProvider.autoDispose<SumUpViewModel, SumUpState>(
        (ref) => SumUpViewModel(ref));

class SumUpViewModel extends StateNotifier<SumUpState> {
  late Ref ref;

  SumUpViewModel(this.ref) : super(SumUpState.initial()) {
    ref.read(textToSpeechService).sayActivitySumUp();
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
