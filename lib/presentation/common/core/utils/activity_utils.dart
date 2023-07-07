import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../domain/entities/enum/activity_type.dart';

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
}
