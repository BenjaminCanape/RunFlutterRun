import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../viewmodel/timer_view_model.dart';

/// A floating action button used to pause or resume the timer.
class TimerPause extends HookConsumerWidget {
  const TimerPause({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRunning = ref.watch(timerViewModelProvider).isRunning;
    final timerViewModel = ref.watch(timerViewModelProvider.notifier);

    if (timerViewModel.hasTimerStarted()) {
      return FloatingActionButton(
        backgroundColor: Colors.teal.shade800,
        tooltip: timerViewModel.isTimerRunning() ? 'Pause' : 'Resume',
        child: Icon(isRunning ? Icons.pause : Icons.play_arrow),
        onPressed: () {
          if (timerViewModel.isTimerRunning()) {
            timerViewModel.pauseTimer();
          } else {
            timerViewModel.startTimer();
          }
        },
      );
    }
    return const SizedBox.shrink();
  }
}
