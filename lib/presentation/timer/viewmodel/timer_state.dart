class TimerState {
  final int hours;
  final int minutes;
  final int secondes;

  final bool isRunning;

  const TimerState(
      {required this.hours,
      required this.minutes,
      required this.secondes,
      required this.isRunning});

  factory TimerState.initial() {
    return const TimerState(
        hours: 0, minutes: 0, secondes: 0, isRunning: false);
  }

  TimerState copyWith(
      {int? hours, int? minutes, int? secondes, bool? isRunning}) {
    return TimerState(
        hours: hours ?? this.hours,
        minutes: minutes ?? this.minutes,
        secondes: secondes ?? this.secondes,
        isRunning: isRunning ?? this.isRunning);
  }
}
