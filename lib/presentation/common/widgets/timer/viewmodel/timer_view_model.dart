import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:run_flutter_run/main.dart';
import 'package:wakelock/wakelock.dart';

import '../../../textToSpeech/text_to_speech.dart';
import '../../location/view_model/location_view_model.dart';
import 'timer_state.dart';

final timerViewModelProvider =
    StateNotifierProvider.autoDispose<TimerViewModel, TimerState>(
  (ref) => TimerViewModel(ref),
);

class TimerViewModel extends StateNotifier<TimerState> {
  final Ref ref;
  Timer? timer;
  Stopwatch stopwatch = Stopwatch();

  TimerViewModel(this.ref) : super(TimerState.initial());

  void startTimer() {
    bool isRunning = hasTimerStarted();
    stopwatch.start();
    state = state.copyWith(startDatetime: DateTime.now(), isRunning: true);
    timer = Timer.periodic(const Duration(seconds: 1), updateTime);
    if (!isRunning) {
      ref.read(textToSpeechService).sayGoodLuck();
      Wakelock.enable();
    } else {
      ref.read(textToSpeechService).sayResume();
      ref.read(locationViewModelProvider.notifier).resumeLocationStream();
    }
  }

  bool hasTimerStarted() {
    return stopwatch.elapsedMilliseconds > 0;
  }

  bool isTimerRunning() {
    return stopwatch.isRunning;
  }

  void resetTimer() {
    state = TimerState.initial();
  }

  void stopTimer() {
    stopwatch.stop();
    stopwatch.reset();
    timer?.cancel();
    ref.read(locationViewModelProvider.notifier).cancelLocationStream();
    state = state.copyWith(isRunning: false);
    ref.read(textToSpeechService).sayCongrats();
    Wakelock.disable();
    navigatorKey.currentState?.pushNamed('/sumup');
  }

  void pauseTimer() {
    ref.read(textToSpeechService).sayPause();
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
    int seconds = convertMillisToSeconds(timerInMs, hours, minutes);
    state = state.copyWith(hours: hours, minutes: minutes, seconds: seconds);
  }

  String getFormattedTime([int? timeInMs]) {
    int hours = state.hours;
    int minutes = state.minutes;
    int seconds = state.seconds;

    if (timeInMs != null) {
      hours = convertMillisToHours(timeInMs);
      minutes = convertMillisToMinutes(timeInMs, hours);
      seconds = convertMillisToSeconds(timeInMs, hours, minutes);
    }

    String hoursFormatted = hours.toString().padLeft(2, '0');
    String minutesFormatted = minutes.toString().padLeft(2, '0');
    String secondsFormatted = seconds.toString().padLeft(2, '0');

    String formattedTime = hours > 0
        ? '$hoursFormatted:$minutesFormatted:$secondsFormatted'
        : '$minutesFormatted:$secondsFormatted';

    return formattedTime;
  }

  int convertMillisToHours(int ms) {
    return ms ~/ 3600000;
  }

  int convertMillisToMinutes(int ms, int hoursToSubtract) {
    return (ms - (hoursToSubtract * 3600000)) ~/ 60000;
  }

  int convertMillisToSeconds(
      int ms, int hoursToSubtract, int minutesToSubtract) {
    return (ms - (hoursToSubtract * 3600000 + minutesToSubtract * 60000)) ~/
        1000;
  }
}
