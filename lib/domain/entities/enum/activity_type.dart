import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Enum representing different types of activities.
enum ActivityType { running, walking, cycling }

/// Extension on ActivityType to provide translated names based on the given localization.
extension ActivityTypeExtension on ActivityType {
  /// Retrieves the translated name of the activity type based on the provided localization.
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
