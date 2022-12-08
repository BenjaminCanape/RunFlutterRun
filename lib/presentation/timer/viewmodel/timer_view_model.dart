import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:run_run_run/presentation/common/textToSpeech/text_to_speech.dart';
import 'package:run_run_run/presentation/location/view_model/location_view_model.dart';
import 'package:run_run_run/presentation/metrics/view_model/metrics_view_model.dart';
import 'package:run_run_run/presentation/timer/viewmodel/timer_state.dart';

final timerViewModelProvider =
    StateNotifierProvider.autoDispose<TimerViewModel, TimerState>(
        (ref) => TimerViewModel(ref));

class TimerViewModel extends StateNotifier<TimerState> {
  final Ref ref;
  Timer? timer;
  Stopwatch stopwatch = Stopwatch();
  TimerViewModel(this.ref) : super(TimerState.initial());

  void startTimer() {
    bool isRunning = stopwatch.elapsedMilliseconds > 0;
    stopwatch.start();
    state = state.copyWith(isRunning: true);
    timer = Timer.periodic(new Duration(seconds: 1), updateTime);
    if (isRunning == false) {
      ref.read(locationViewModelProvider.notifier).startGettingLocation();
      ref.read(textToSpeechService).sayGoodLuck();
    } else {
      ref.read(locationViewModelProvider.notifier).resumeLocationStream();
    }
  }

  bool isTimerRunning() {
    return stopwatch.isRunning;
  }

  void resetTimer() {
    state = TimerState.initial();
    stopwatch.reset();
    timer?.cancel();
    ref.read(locationViewModelProvider.notifier).cancelLocationStream();
    ref.read(metricsViewModelProvider.notifier).reset();
    state = state.copyWith(isRunning: false);
  }

  void stopTimer() {
    stopwatch.stop();
    timer?.cancel();
    ref.read(locationViewModelProvider.notifier).stopLocationStream();
    state = state.copyWith(isRunning: false);
  }

  int getTimerInMs() {
    return stopwatch.elapsedMilliseconds;
  }

  void updateTime(Timer timer) {
    int timerInMs = stopwatch.elapsedMilliseconds;
    int hours = convertMillisToHours(timerInMs);
    int minutes = convertMillisToMinutes(timerInMs, hours);
    int secondes = convertMillisToSeconds(timerInMs, hours, minutes);
    state = state.copyWith(hours: hours, minutes: minutes, secondes: secondes);
  }

  String getFormattedTime() {
    String hoursFormatted = state.hours.toString().padLeft(2, '0');
    String minFormatted = state.minutes.toString().padLeft(2, '0');
    String secFormatted = state.secondes.toString().padLeft(2, '0');

    String formattedTime = state.hours > 0
        ? '$hoursFormatted:$minFormatted:$secFormatted'
        : '$minFormatted:$secFormatted';

    return formattedTime;
  }

  int convertMillisToHours(int ms) {
    return ms ~/ 3600000;
  }

  int convertMillisToMinutes(int ms, int hoursToSubstract) {
    return (ms - (hoursToSubstract * 3600000)) ~/ 60000;
  }

  int convertMillisToSeconds(
      int ms, int hoursToSubstract, int minutesToSubstract) {
    return (ms - (hoursToSubstract * 3600000 + minutesToSubstract * 60000)) ~/
        1000;
  }
}
