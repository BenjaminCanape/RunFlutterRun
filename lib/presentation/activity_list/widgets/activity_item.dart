import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/entities/activity.dart';

class ActivityItem extends HookConsumerWidget {
  final Activity activity;
  const ActivityItem({Key? key, required this.activity}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(children: [
      Text(
        '${AppLocalizations.of(context).date_pronoun} ${DateFormat('dd/MM/yyyy').format(activity.startDatetime)} ${AppLocalizations.of(context).hours_pronoun} ${DateFormat('kk:mm').format(activity.startDatetime)}:',
      ),
      Text(
        '${AppLocalizations.of(context).distance}: ${activity.distance.toStringAsFixed(2)} km  - ${AppLocalizations.of(context).speed}: ${activity.speed.toStringAsFixed(2)} km/h',
      )
    ]);
  }
}
