import 'package:flutter/material.dart';
import 'package:run_run_run/presentation/timer/viewmodel/timer_view_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../location/screen/location_screen.dart';
import '../../metrics/screen/metrics_screen.dart';
import '../../timer/screen/timer_screen.dart';
import '../widgets/save_button.dart';

class SumUpScreen extends HookConsumerWidget {
  const SumUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(timerViewModelProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text("Resumé de l'activité:"),
            TimerScreen(),
            MetricsScreen(),
            const SizedBox(
              height: 10,
            ),
            LocationScreen(),
          ],
        ),
      ),
      floatingActionButton: const SaveButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 4.0,
        color: Colors.blue,
        child: IconTheme(
            data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
            child: Row(
              children: <Widget>[
                IconButton(
                  tooltip: 'Home',
                  icon: const Icon(Icons.run_circle),
                  onPressed: () {},
                ),
                const Spacer(),
              ],
            )),
      ),
    );
  }
}
