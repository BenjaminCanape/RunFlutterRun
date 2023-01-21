class TimerState {
  final DateTime startDatetime;

  final int hours;
  final int minutes;
  final int secondes;

  final bool isRunning;

  const TimerState(
      {required this.hours,
      required this.minutes,
      required this.secondes,
      required this.isRunning,
      required this.startDatetime});

  factory TimerState.initial() {
    return TimerState(
        startDatetime: DateTime.now(),
        hours: 0,
        minutes: 0,
        secondes: 0,
        isRunning: false);
  }

  TimerState copyWith(
      {DateTime? startDatetime,
      int? hours,
      int? minutes,
      int? secondes,
      bool? isRunning}) {
    return TimerState(
        startDatetime: startDatetime ?? this.startDatetime,
        hours: hours ?? this.hours,
        minutes: minutes ?? this.minutes,
        secondes: secondes ?? this.secondes,
        isRunning: isRunning ?? this.isRunning);
  }
}
