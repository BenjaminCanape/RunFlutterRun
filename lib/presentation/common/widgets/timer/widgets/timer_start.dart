import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../viewmodel/timer_view_model.dart';

class TimerStart extends HookConsumerWidget {
  const TimerStart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ignore: unused_local_variable
    final state = ref.watch(timerViewModelProvider);
    final timerViewModel = ref.watch(timerViewModelProvider.notifier);

    return FloatingActionButton(
      backgroundColor: timerViewModel.hasTimerStarted()
          ? Colors.red.shade700
          : Colors.teal.shade800,
      elevation: 4.0,
      child: Icon(
          timerViewModel.hasTimerStarted() ? Icons.stop : Icons.play_arrow),
      onPressed: () {
        if (timerViewModel.hasTimerStarted()) {
          timerViewModel.stopTimer();
        } else {
          timerViewModel.startTimer();
        }
      },
    );
  }
}
