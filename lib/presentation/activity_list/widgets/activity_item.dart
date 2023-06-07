import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/entities/activity.dart';
import '../view_model/activity_list_view_model.dart';

class ActivityItem extends HookConsumerWidget {
  final Activity activity;
  const ActivityItem({Key? key, required this.activity}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.read(activityListViewModelProvider.notifier);
    var navigator = Navigator.of(context);

    return InkWell(
      onTap: () {
        provider.getActivityDetails(activity).then((activityDetails) {
          provider.goToActivity(navigator, activityDetails);
        });
      },
      child: Card(
        child: ListTile(
          leading: const Icon(
            Icons.run_circle_rounded,
            color: Colors.blueGrey,
          ),
          subtitle:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              '${AppLocalizations.of(context).running}'.toUpperCase(),
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${AppLocalizations.of(context).date_pronoun} ${DateFormat('dd/MM/yyyy').format(activity.startDatetime)} ${AppLocalizations.of(context).hours_pronoun} ${DateFormat('kk:mm').format(activity.startDatetime)}',
            ),
            Text(
              '${AppLocalizations.of(context).distance}: ${activity.distance.toStringAsFixed(2)} km  - ${AppLocalizations.of(context).speed}: ${activity.speed.toStringAsFixed(2)} km/h',
            )
          ]),
        ),
      ),
    );
  }
}
