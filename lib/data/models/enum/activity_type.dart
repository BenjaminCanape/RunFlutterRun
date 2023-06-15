import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum ActivityType { running, walking, cycling }

extension StringExtension on ActivityType {
  String get name {
    return toString().split('.').last;
  }
}

String translateActivityTypeValue(
    AppLocalizations localization, ActivityType type) {
  var translated = {
    "running": localization.running,
    "walking": localization.walking,
    "cycling": localization.cycling,
  };

  var defaultValue = translated.entries.isNotEmpty
      ? translated.entries.first.value
      : 'running';

  var translatedValue = translated.entries
      .firstWhere((element) => element.key == type.name,
          orElse: () => MapEntry("", defaultValue))
      .value;

  return translatedValue;
}
