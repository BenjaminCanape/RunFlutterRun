import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum ActivityType { running, walking, cycling }

extension ActivityTypeExtension on ActivityType {
  String getTranslatedName(AppLocalizations localization) {
    switch (this) {
      case ActivityType.running:
        return localization.running;
      case ActivityType.walking:
        return localization.walking;
      case ActivityType.cycling:
        return localization.cycling;
      default:
        return '';
    }
  }
}

String translateActivityTypeValue(
    AppLocalizations localization, ActivityType type) {
  return type.getTranslatedName(localization);
}
