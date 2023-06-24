import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/models/enum/activity_type.dart';
import '../../../domain/entities/activity.dart';
import '../../common/ui/activity.dart';
import '../../common/widgets/date/date.dart';
import '../view_model/activity_list_view_model.dart';

class ActivityItem extends HookConsumerWidget {
  final Activity activity;
  const ActivityItem({Key? key, required this.activity}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.read(activityListViewModelProvider.notifier);
    var navigator = Navigator.of(context);

    return InkWell(
      onTap: () async {
        var activityDetails = await provider.getActivityDetails(activity);
        provider.goToActivity(navigator, activityDetails);
      },
      child: Card(
        child: ListTile(
          leading: Icon(
            getActivityTypeIcon(activity),
            color: Colors.blueGrey,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                translateActivityTypeValue(
                  AppLocalizations.of(context),
                  activity.type,
                ).toUpperCase(),
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Date(date: activity.startDatetime),
              Text(
                '${AppLocalizations.of(context).distance}: ${activity.distance.toStringAsFixed(2)} km  - ${AppLocalizations.of(context).speed}: ${activity.speed.toStringAsFixed(2)} km/h',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
