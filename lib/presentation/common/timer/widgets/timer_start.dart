import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/utils/color_utils.dart';
import '../viewmodel/timer_view_model.dart';

/// A widget that displays the timer start button.
class TimerStart extends HookConsumerWidget {
  const TimerStart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ignore: unused_local_variable
    final state = ref.watch(timerViewModelProvider);
    final timerViewModel = ref.watch(timerViewModelProvider.notifier);

    return FloatingActionButton(
      backgroundColor:
          timerViewModel.hasTimerStarted() ? ColorUtils.red : ColorUtils.main,
      elevation: 4.0,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return ScaleTransition(
            scale: animation,
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        child: Icon(
          timerViewModel.hasTimerStarted() ? Icons.stop : Icons.play_arrow,
          key: ValueKey<bool>(timerViewModel.hasTimerStarted()),
          color: ColorUtils.white,
        ),
      ),
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
