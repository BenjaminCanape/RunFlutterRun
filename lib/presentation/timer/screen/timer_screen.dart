import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../viewmodel/timer_view_model.dart';
import '../widgets/timer_text.dart';

class TimerScreen extends HookConsumerWidget {
  const TimerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ignore: unused_local_variable
    final state = ref.watch(timerViewModelProvider);
    // ignore: unused_local_variable
    final timerViewModel = ref.watch(timerViewModelProvider.notifier);

    return const Column(
      children: <Widget>[
        SizedBox(
            height: 200.0,
            child: Center(
              child: TimerText(),
            )),
      ],
    );
  }
}
