import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/models/enum/activity_type.dart';
import '../../common/widgets/location/widgets/location.dart';
import '../../common/widgets/metrics/widgets/metrics.dart';
import '../../common/widgets/timer/widgets/timer_sized.dart';
import '../view_model/sum_up_view_model.dart';
import '../widgets/save_button.dart';

class SumUpScreen extends HookConsumerWidget {
  const SumUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sumUpViewModelProvider);
    final provider = ref.watch(sumUpViewModelProvider.notifier);
    ActivityType selectedType = state.type;
    List<ActivityType> types = ActivityType.values;

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
          : SafeArea(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownButton<ActivityType>(
                    value: selectedType,
                    items: types.map((ActivityType value) {
                      return DropdownMenuItem<ActivityType>(
                        value: value,
                        child: Text(
                          translateActivityTypeValue(
                              AppLocalizations.of(context), value),
                        ),
                      );
                    }).toList(),
                    onChanged: (ActivityType? newValue) {
                      if (newValue != null) {
                        provider.setType(newValue);
                      }
                    },
                  ),
                  const TimerSized(),
                  const Metrics(),
                  const SizedBox(
                    height: 10,
                  ),
                  const Location(),
                ],
              ),
            ),
      floatingActionButton: SaveButton(disabled: state.isSaving),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
