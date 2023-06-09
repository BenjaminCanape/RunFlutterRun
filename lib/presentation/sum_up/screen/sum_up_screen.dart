import 'package:flutter/material.dart';
import '../../common/widgets/timer/widgets/timer_sized.dart';
import '../../common/widgets/location/widgets/location.dart';
import '../../common/widgets/metrics/widgets/metrics.dart';
import '../view_model/sum_up_view_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../widgets/save_button.dart';

class SumUpScreen extends HookConsumerWidget {
  const SumUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sumUpViewModelProvider);

    return Scaffold(
      appBar: AppBar(
          leadingWidth: 0,
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
              color: Colors.grey.shade800,
              fontSize: 24,
              fontWeight: FontWeight.bold),
          title:
              Text(AppLocalizations.of(context).activity_sumup.toUpperCase())),
      body: state.isSaving
          ? const Center(child: CircularProgressIndicator())
          : const SafeArea(
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
      floatingActionButton: SaveButton(disabled: state.isSaving),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
