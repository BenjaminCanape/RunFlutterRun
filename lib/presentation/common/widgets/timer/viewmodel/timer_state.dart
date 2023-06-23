class TimerState {
  final DateTime startDatetime;
  final int hours;
  final int minutes;
  final int seconds;
  final bool isRunning;

  const TimerState({
    required this.startDatetime,
    required this.hours,
    required this.minutes,
    required this.seconds,
    required this.isRunning,
  });

  factory TimerState.initial() {
    return TimerState(
      startDatetime: DateTime.now(),
      hours: 0,
      minutes: 0,
      seconds: 0,
      isRunning: false,
    );
  }

  TimerState copyWith({
    DateTime? startDatetime,
    int? hours,
    int? minutes,
    int? seconds,
    bool? isRunning,
  }) {
    return TimerState(
      startDatetime: startDatetime ?? this.startDatetime,
      hours: hours ?? this.hours,
      minutes: minutes ?? this.minutes,
      seconds: seconds ?? this.seconds,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}
