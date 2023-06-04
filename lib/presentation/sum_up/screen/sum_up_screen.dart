import 'package:flutter/material.dart';
import '../view_model/sum_up_view_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../location/screen/location_screen.dart';
import '../../metrics/screen/metrics_screen.dart';
import '../../timer/screen/timer_screen.dart';
import '../widgets/save_button.dart';

class SumUpScreen extends HookConsumerWidget {
  const SumUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sumUpViewModelProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text(AppLocalizations.of(context).activity_sumup),
            TimerScreen(),
            MetricsScreen(),
            const SizedBox(
              height: 10,
            ),
            LocationScreen(),
          ],
        ),
      ),
      floatingActionButton: SaveButton(disabled: state.isSaving),
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
