import 'package:flutter/material.dart';
import 'package:run_run_run/presentation/timer/viewmodel/timer_view_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../widgets/timer_text.dart';

class TimerScreen extends HookConsumerWidget {
  const TimerScreen({Key? key}) : super(key: key);

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
      ],
    );
  }
}
