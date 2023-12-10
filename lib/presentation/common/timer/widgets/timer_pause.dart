import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/utils/color_utils.dart';
import '../viewmodel/timer_view_model.dart';

/// A floating action button used to pause or resume the timer.
class TimerPause extends HookConsumerWidget {
  const TimerPause({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRunning = ref.watch(timerViewModelProvider).isRunning;
    final timerViewModel = ref.watch(timerViewModelProvider.notifier);

    if (timerViewModel.hasTimerStarted()) {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return ScaleTransition(
            scale: animation,
            child: child,
          );
        },
        child: FloatingActionButton(
          backgroundColor: ColorUtils.main,
          key: ValueKey<bool>(isRunning),
          tooltip: timerViewModel.isTimerRunning() ? 'Pause' : 'Resume',
          child: Icon(
            isRunning ? Icons.pause : Icons.play_arrow,
            color: ColorUtils.white,
          ),
          onPressed: () {
            if (timerViewModel.isTimerRunning()) {
              timerViewModel.pauseTimer();
            } else {
              timerViewModel.startTimer();
            }
          },
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
