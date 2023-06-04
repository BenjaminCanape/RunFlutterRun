import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../viewmodel/timer_view_model.dart';

class TimerStart extends HookConsumerWidget {
  const TimerStart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ignore: unused_local_variable
    final state = ref.watch(timerViewModelProvider);
    final timerViewModel = ref.watch(timerViewModelProvider.notifier);

    return FloatingActionButton(
      elevation: 4.0,
      child: Icon(timerViewModel.hasTimerStarted() == true
          ? Icons.stop
          : Icons.play_arrow),
      onPressed: () {
        timerViewModel.hasTimerStarted() == true
            ? timerViewModel.stopTimer(context)
            : timerViewModel.startTimer();
      },
    );
  }
}
