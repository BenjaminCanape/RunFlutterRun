import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/location/widgets/current_location_map.dart';
import '../../common/metrics/widgets/metrics.dart';
import '../../common/timer/viewmodel/timer_view_model.dart';
import '../../common/timer/widgets/timer_pause.dart';
import '../../common/timer/widgets/timer_sized.dart';
import '../../common/timer/widgets/timer_start.dart';

/// The screen for creating a new activity.
class NewActivityScreen extends HookConsumerWidget {
  const NewActivityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerViewModel = ref.watch(timerViewModelProvider.notifier);
    // ignore: unused_local_variable
    final isRunning =
        ref.watch(timerViewModelProvider.select((value) => value.isRunning));

    return Scaffold(
      body: const SafeArea(
        child: Column(
          children: [
            TimerTextSized(),
            Metrics(),
            SizedBox(height: 10),
            CurrentLocationMap(),
          ],
        ),
      ),
      floatingActionButton: timerViewModel.hasTimerStarted()
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
