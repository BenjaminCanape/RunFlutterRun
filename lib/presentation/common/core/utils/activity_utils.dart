import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../domain/entities/enum/activity_type.dart';
import '../../../activity_details/view_model/activity_details_view_model.dart';
import '../../../sum_up/view_model/sum_up_view_model.dart';

/// Utility class for activity-related operations.
class ActivityUtils {
  /// Returns the icon associated with the given activity type.
  ///
  /// Returns [Icons.run_circle_outlined] for [ActivityType.running],
  /// [Icons.nordic_walking] for [ActivityType.walking],
  /// [Icons.pedal_bike] for [ActivityType.cycling], and
  /// [Icons.run_circle_rounded] for any other activity type.
  static IconData getActivityTypeIcon(ActivityType type) {
    switch (type) {
      case ActivityType.running:
        return Icons.run_circle_outlined;
      case ActivityType.walking:
        return Icons.nordic_walking;
      case ActivityType.cycling:
        return Icons.pedal_bike;
      default:
        return Icons.run_circle_rounded;
    }
  }

  /// Translates the name of the activity type using the provided localization.
  ///
  /// The [localization] is used to translate the activity type name.
  static String translateActivityTypeValue(
      AppLocalizations localization, ActivityType type) {
    return type.getTranslatedName(localization);
  }

  /// Builds the dropdown button for selecting the activity type.
  static Widget buildActivityTypeDropdown<T>(
    BuildContext context,
    ActivityType selectedType,
    T provider,
  ) {
    List<DropdownMenuItem<ActivityType>> dropdownItems = ActivityType.values
        .map((ActivityType value) => DropdownMenuItem<ActivityType>(
              value: value,
              child: Row(children: [
                Icon(ActivityUtils.getActivityTypeIcon(value)),
                const SizedBox(width: 10),
                Text(
                  ActivityUtils.translateActivityTypeValue(
                    AppLocalizations.of(context),
                    value,
                  ),
                )
              ]),
            ))
        .toList();

    return DropdownButton<ActivityType>(
      value: selectedType,
      items: dropdownItems,
      onChanged: (ActivityType? newValue) {
        if (newValue != null && provider is ActivityDetailsViewModel) {
          provider.setType(newValue);
        } else if (newValue != null && provider is SumUpViewModel) {
          provider.setType(newValue);
        }
      },
    );
  }
}
