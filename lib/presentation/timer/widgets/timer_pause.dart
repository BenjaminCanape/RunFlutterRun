import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../viewmodel/timer_view_model.dart';

class TimerPause extends HookConsumerWidget {
  const TimerPause({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(timerViewModelProvider);
    final timerViewModel = ref.watch(timerViewModelProvider.notifier);

    if (timerViewModel.hasTimerStarted()) {
      return IconButton(
        tooltip: timerViewModel.isTimerRunning() == true ? 'Pause' : 'Resume',
        icon: Icon(timerViewModel.isTimerRunning() == true
            ? Icons.pause
            : Icons.play_arrow),
        onPressed: () {
          timerViewModel.isTimerRunning() == true
              ? timerViewModel.stopTimer()
              : timerViewModel.startTimer();
        },
      );
    }
    return const SizedBox();
  }
}
