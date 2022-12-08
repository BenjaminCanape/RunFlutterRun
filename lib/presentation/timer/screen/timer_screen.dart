import 'package:flutter/material.dart';
import 'package:run_run_run/presentation/timer/viewmodel/timer_view_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../widgets/timer_text.dart';

class TimerScreen extends HookConsumerWidget {
  const TimerScreen({Key? key}) : super(key: key);

  void leftButtonPressed(BuildContext context, TimerViewModel timerViewModel) {
    timerViewModel.resetTimer();
  }

  void rightButtonPressed(BuildContext context, TimerViewModel timerViewModel) {
    if (timerViewModel.isTimerRunning()) {
      timerViewModel.stopTimer();
    } else {
      timerViewModel.startTimer();
    }
  }

  Widget buildFloatingButton(
      BuildContext context,
      TimerViewModel timerViewModel,
      String text,
      void Function(BuildContext context, TimerViewModel timerViewModel)
          callback) {
    TextStyle roundTextStyle =
        const TextStyle(fontSize: 16.0, color: Colors.white);
    return FloatingActionButton(
        onPressed: () => callback(context, timerViewModel),
        child: Text(text, style: roundTextStyle));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(timerViewModelProvider);
    final timerViewModel = ref.watch(timerViewModelProvider.notifier);

    return Column(
      children: <Widget>[
        const SizedBox(
            height: 200.0,
            child: Center(
              child: TimerText(),
            )),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              buildFloatingButton(
                  context, timerViewModel, "reset", leftButtonPressed),
              buildFloatingButton(
                  context,
                  timerViewModel,
                  timerViewModel.isTimerRunning() ? "pause" : "start",
                  rightButtonPressed),
            ]),
      ],
    );
  }
}
