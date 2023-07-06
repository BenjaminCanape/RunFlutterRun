import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../domain/entities/enum/activity_type.dart';

class ActivityUtils {
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

  static String translateActivityTypeValue(
      AppLocalizations localization, ActivityType type) {
    return type.getTranslatedName(localization);
  }
}
