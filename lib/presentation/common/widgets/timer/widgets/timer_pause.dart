import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../viewmodel/timer_view_model.dart';

class TimerPause extends HookConsumerWidget {
  const TimerPause({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ignore: unused_local_variable
    final state = ref.watch(timerViewModelProvider);
    final timerViewModel = ref.watch(timerViewModelProvider.notifier);

    if (timerViewModel.hasTimerStarted()) {
      return FloatingActionButton(
        backgroundColor: Colors.teal.shade800,
        tooltip: timerViewModel.isTimerRunning() == true ? 'Pause' : 'Resume',
        child: Icon(timerViewModel.isTimerRunning() == true
            ? Icons.pause
            : Icons.play_arrow),
        onPressed: () {
          timerViewModel.isTimerRunning() == true
              ? timerViewModel.pauseTimer()
              : timerViewModel.startTimer();
        },
      );
    }
    return const SizedBox();
  }
}
