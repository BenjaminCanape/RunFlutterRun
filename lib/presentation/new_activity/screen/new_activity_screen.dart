import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../common/widgets/timer/widgets/timer_sized.dart';

import '../../common/widgets/location/widgets/location.dart';
import '../../common/widgets/metrics/widgets/metrics.dart';
import '../../common/widgets/timer/viewmodel/timer_view_model.dart';
import '../../common/widgets/timer/widgets/timer_pause.dart';
import '../../common/widgets/timer/widgets/timer_start.dart';

class NewActivityScreen extends HookConsumerWidget {
  const NewActivityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var timerProvider = ref.watch(timerViewModelProvider.notifier);

    // ignore: unused_local_variable
    var isRunning = ref.watch(timerViewModelProvider).isRunning;

    return Scaffold(
      body: const SafeArea(
        child: Column(
          children: [
            TimerSized(),
            Metrics(),
            SizedBox(
              height: 10,
            ),
            Location(),
          ],
        ),
      ),
      floatingActionButton: timerProvider.hasTimerStarted()
          ? const Stack(
              children: [
                Positioned(
                  bottom: 16,
                  right: 80,
                  child: TimerPause(),
                ),
                Positioned(
                  bottom: 16,
                  left: 80,
                  child: TimerStart(),
                ),
              ],
            )
          : const TimerStart(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
