import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../viewmodel/timer_view_model.dart';

class TimerPause extends HookConsumerWidget {
  const TimerPause({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerViewModel = ref.watch(timerViewModelProvider.notifier);

    if (timerViewModel.hasTimerStarted()) {
      return FloatingActionButton(
        backgroundColor: Colors.teal.shade800,
        tooltip: timerViewModel.isTimerRunning() == true ? 'Pause' : 'Resume',
        child: Icon(timerViewModel.isTimerRunning() == true
            ? Icons.pause
            : Icons.play_arrow),
        onPressed: () {
          if (timerViewModel.isTimerRunning()) {
            timerViewModel.pauseTimer();
          } else {
            timerViewModel.startTimer();
          }
        },
      );
    }
    return const SizedBox();
  }
}
