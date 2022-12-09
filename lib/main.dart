import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:run_run_run/presentation/metrics/screen/metrics_screen.dart';
import 'package:run_run_run/presentation/timer/widgets/timer_pause.dart';
import 'package:run_run_run/presentation/timer/widgets/timer_start.dart';

import 'presentation/location/screen/location_screen.dart';
import 'presentation/timer/screen/timer_screen.dart';

void main() {
  runApp(
    const ProviderScope(child: MaterialApp(home: MyApp())),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Run Flutter Run',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        bottomSheetTheme:
            const BottomSheetThemeData(backgroundColor: Colors.transparent),
      ),
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: const [
              MetricsScreen(),
              LocationScreen(),
              TimerScreen(),
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
              data:
                  IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
              child: Row(
                children: <Widget>[
                  IconButton(
                    tooltip: 'Home',
                    icon: const Icon(Icons.run_circle),
                    onPressed: () {},
                  ),
                  const Spacer(),
                  const TimerPause(),
                ],
              )),
        ),
      ),
    );
  }
}
