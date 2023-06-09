import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../location/screen/location_screen.dart';
import '../../metrics/screen/metrics_screen.dart';
import '../../timer/screen/timer_screen.dart';
import '../../timer/viewmodel/timer_view_model.dart';
import '../../timer/widgets/timer_pause.dart';
import '../../timer/widgets/timer_start.dart';

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
            TimerScreen(),
            MetricsScreen(),
            SizedBox(
              height: 10,
            ),
            LocationScreen(),
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
