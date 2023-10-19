class TimerState {
  final DateTime startDatetime;
  final int hours;
  final int minutes;
  final int seconds;
  final bool isRunning;

  /// Represents the state of a timer.
  const TimerState({
    required this.startDatetime,
    required this.hours,
    required this.minutes,
    required this.seconds,
    required this.isRunning,
  });

  /// Creates the initial state of a timer.
  factory TimerState.initial() {
    return TimerState(
      startDatetime: DateTime.now(),
      hours: 0,
      minutes: 0,
      seconds: 0,
      isRunning: false,
    );
  }

  /// Creates a copy of the current state with optional changes.
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
