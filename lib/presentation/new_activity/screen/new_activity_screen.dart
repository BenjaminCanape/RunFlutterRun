import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:run_run_run/presentation/timer/viewmodel/timer_view_model.dart';
import 'package:run_run_run/presentation/timer/widgets/timer_pause.dart';

import '../../location/screen/location_screen.dart';
import '../../metrics/screen/metrics_screen.dart';
import '../../timer/screen/timer_screen.dart';
import '../../timer/widgets/timer_start.dart';

class NewActivityScreen extends HookConsumerWidget {
  const NewActivityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var timerProvider = ref.watch(timerViewModelProvider.notifier);

    // ignore: unused_local_variable
    var isRunning = ref.watch(timerViewModelProvider).isRunning;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const TimerScreen(),
            const MetricsScreen(),
            const SizedBox(
              height: 10,
            ),
            LocationScreen(),
          ],
        ),
      ),
      floatingActionButton: timerProvider.hasTimerStarted()
          ? const Stack(
              children: [
                // Premier bouton d'action flottant
                Positioned(
                  bottom: 16,
                  right: 80,
                  child: TimerPause(),
                ),

                // Deuxième bouton d'action flottant
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
