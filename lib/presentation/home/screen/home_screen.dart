import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../location/screen/location_screen.dart';
import '../../metrics/screen/metrics_screen.dart';
import '../../timer/screen/timer_screen.dart';
import '../../timer/widgets/timer_pause.dart';
import '../../timer/widgets/timer_start.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
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
      floatingActionButton: const TimerStart(),
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
                  onPressed: () {
                    Navigator.pushNamed(context, '/activity_list');
                  },
                ),
                const Spacer(),
                const TimerPause(),
              ],
            )),
      ),
    );
  }
}
