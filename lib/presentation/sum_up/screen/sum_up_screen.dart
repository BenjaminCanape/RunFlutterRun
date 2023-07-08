import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/entities/enum/activity_type.dart';
import '../../common/core/utils/activity_utils.dart';
import '../../common/core/utils/ui_utils.dart';
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
      body: state.isSaving
          ? const Center(child: UIUtils.loader)
          : SafeArea(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 0, top: 12),
                    child: Text(
                      AppLocalizations.of(context).activity_sumup,
                      style: const TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Divider(),
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

  /// Builds the dropdown button for selecting the activity type.
  Widget buildActivityTypeDropdown(BuildContext context,
      ActivityType selectedType, SumUpViewModel provider) {
    List<DropdownMenuItem<ActivityType>> dropdownItems = ActivityType.values
        .map((ActivityType value) => DropdownMenuItem<ActivityType>(
              value: value,
              child: Row(children: [
                Icon(ActivityUtils.getActivityTypeIcon(value)),
                const SizedBox(width: 10),
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
