import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/entities/enum/activity_type.dart';
import '../../common/core/utils/activity_utils.dart';
import '../../common/location/widgets/current_location_map.dart';
import '../../common/metrics/widgets/metrics.dart';
import '../../common/timer/widgets/timer_sized.dart';
import '../view_model/sum_up_view_model.dart';
import '../widgets/save_button.dart';

class SumUpScreen extends HookConsumerWidget {
  const SumUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sumUpViewModelProvider);
    final provider = ref.watch(sumUpViewModelProvider.notifier);
    ActivityType selectedType = state.type;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 0,
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
          color: Colors.grey.shade800,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        title: Text(
          AppLocalizations.of(context).activity_sumup.toUpperCase(),
        ),
      ),
      body: state.isSaving
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  buildActivityTypeDropdown(context, selectedType, provider),
                  const TimerTextSized(),
                  const Metrics(),
                  const SizedBox(height: 10),
                  const CurrentLocationMap(),
                ],
              ),
            ),
      floatingActionButton: SaveButton(disabled: state.isSaving),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget buildActivityTypeDropdown(BuildContext context,
      ActivityType selectedType, SumUpViewModel provider) {
    List<DropdownMenuItem<ActivityType>> dropdownItems = ActivityType.values
        .map((ActivityType value) => DropdownMenuItem<ActivityType>(
              value: value,
              child: Row(children: [
                Icon(ActivityUtils.getActivityTypeIcon(value)),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  ActivityUtils.translateActivityTypeValue(
                      AppLocalizations.of(context), value),
                )
              ]),
            ))
        .toList();

    return DropdownButton<ActivityType>(
      value: selectedType,
      items: dropdownItems,
      onChanged: (ActivityType? newValue) {
        if (newValue != null) {
          provider.setType(newValue);
        }
      },
    );
  }
}
