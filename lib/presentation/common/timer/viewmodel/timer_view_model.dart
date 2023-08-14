import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakelock/wakelock.dart';

import '../../../../../main.dart';
import '../../core/services/text_to_speech_service.dart';
import '../../location/view_model/location_view_model.dart';
import '../../metrics/view_model/metrics_view_model.dart';
import 'timer_state.dart';

final timerViewModelProvider =
    StateNotifierProvider.autoDispose<TimerViewModel, TimerState>(
  (ref) => TimerViewModel(ref),
);

class TimerViewModel extends StateNotifier<TimerState> {
  final Ref ref;
  Timer? timer;
  Stopwatch stopwatch = Stopwatch();

  /// Represents the view model for a timer.
  TimerViewModel(this.ref) : super(TimerState.initial());

  /// Starts the timer.
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

  /// Checks if the timer has already started.
  bool hasTimerStarted() {
    return stopwatch.elapsedMilliseconds > 0;
  }

  /// Checks if the timer is currently running.
  bool isTimerRunning() {
    return stopwatch.isRunning;
  }

  /// Resets the timer.
  void resetTimer() {
    state = TimerState.initial();
  }

  /// Stops the timer.
  void stopTimer() async {
    stopwatch.stop();

    final appProvider = ref.read(myAppProvider);
    final l10nConf = await appProvider.getLocalizedConf();
    final metricsProvider = ref.read(metricsViewModelProvider);
    final distance = metricsProvider.distance;
    final globalSpeed = metricsProvider.globalSpeed;

    var textToSay = StringBuffer();

    textToSay.write('${l10nConf.congrats}.');

    String distanceStr = distance.toStringAsFixed(2);
    String kmStr = distanceStr.split('.')[0];
    String metersStr = distanceStr.split('.')[1];

    if (metersStr.startsWith('0')) {
      textToSay
          .write("${l10nConf.distance}: $distanceStr ${l10nConf.kilometers}.");
    } else {
      textToSay.write(
          "${l10nConf.distance}: $kmStr,$metersStr ${l10nConf.kilometers}.");
    }

    var duration = StringBuffer();
    if (state.hours != 0) {
      duration.write("${state.hours} ${l10nConf.hours}");
    }
    if (state.minutes != 0) {
      duration.write("${state.minutes} ${l10nConf.minutes}");
    }
    if (state.seconds != 0) {
      duration.write("${state.seconds} ${l10nConf.seconds}");
    }

    textToSay.write('${l10nConf.duration}: $duration.');

    String speedStr = globalSpeed.toStringAsFixed(2);
    String km = speedStr.split('.')[0];
    String meters = speedStr.split('.')[1];

    if (meters.startsWith('0')) {
      textToSay.write(
          "${l10nConf.speed}: $speedStr ${l10nConf.kilometers} ${l10nConf.per} ${l10nConf.hours}");
    } else {
      textToSay.write(
          "${l10nConf.speed}: $km,$meters ${l10nConf.kilometers} ${l10nConf.per} ${l10nConf.hours}");
    }

    await ref.read(textToSpeechService).say(textToSay.toString());

    ref.read(locationViewModelProvider.notifier).cancelLocationStream();

    stopwatch.reset();
    timer?.cancel();
    state = state.copyWith(isRunning: false);

    Wakelock.disable();
    navigatorKey.currentState?.pushNamed('/sumup');
  }

  /// Pauses the timer.
  void pauseTimer() {
    ref.read(textToSpeechService).sayPause();
    stopwatch.stop();
    timer?.cancel();
    ref.read(locationViewModelProvider.notifier).stopLocationStream();
    state = state.copyWith(isRunning: false);
  }

  /// Gets the timer value in milliseconds.
  int getTimerInMs() {
    return stopwatch.elapsedMilliseconds;
  }

  /// Updates the timer state with the current time.
  void updateTime(Timer timer) {
    int timerInMs = stopwatch.elapsedMilliseconds;
    int hours = convertMillisToHours(timerInMs);
    int minutes = convertMillisToMinutes(timerInMs, hours);
    int seconds = convertMillisToSeconds(timerInMs, hours, minutes);
    state = state.copyWith(hours: hours, minutes: minutes, seconds: seconds);
  }

  /// Converts the time in milliseconds to a formatted string.
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

  /// Converts milliseconds to hours.
  int convertMillisToHours(int ms) {
    return ms ~/ Duration.millisecondsPerHour;
  }

  /// Converts milliseconds to minutes, subtracting the hours.
  int convertMillisToMinutes(int ms, int hoursToSubtract) {
    return (ms - (hoursToSubtract * Duration.millisecondsPerHour)) ~/
        Duration.millisecondsPerMinute;
  }

  /// Converts milliseconds to seconds, subtracting the hours and minutes.
  int convertMillisToSeconds(
      int ms, int hoursToSubtract, int minutesToSubtract) {
    return (ms -
            (hoursToSubtract * Duration.millisecondsPerHour +
                minutesToSubtract * Duration.millisecondsPerMinute)) ~/
        Duration.millisecondsPerSecond;
  }
}
