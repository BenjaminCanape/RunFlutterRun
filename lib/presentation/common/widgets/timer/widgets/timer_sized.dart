import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../viewmodel/timer_view_model.dart';
import 'timer_text.dart';

class TimerSized extends HookConsumerWidget {
  const TimerSized({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ignore: unused_local_variable
    final state = ref.watch(timerViewModelProvider);
    // ignore: unused_local_variable
    final timerViewModel = ref.watch(timerViewModelProvider.notifier);

    return const Column(
      children: <Widget>[
        SizedBox(
          height: 125,
          child: Center(
            child: TimerText(),
          ),
        ),
      ],
    );
  }
}
