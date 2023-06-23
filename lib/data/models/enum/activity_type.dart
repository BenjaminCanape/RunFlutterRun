import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum ActivityType { running, walking, cycling }

extension StringExtension on ActivityType {
  String get name {
    return toString().split('.').last;
  }
}

String translateActivityTypeValue(
    AppLocalizations localization, ActivityType type) {
  final translated = {
    ActivityType.running.name: localization.running,
    ActivityType.walking.name: localization.walking,
    ActivityType.cycling.name: localization.cycling,
  };

  final defaultValue =
      translated.isNotEmpty ? translated.values.first : localization.running;

  final translatedValue = translated[type.name] ?? defaultValue;

  return translatedValue;
}
