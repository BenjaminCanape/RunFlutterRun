import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../../../../domain/entities/activity.dart';
import '../../core/utils/activity_utils.dart';
import '../../core/utils/color_utils.dart';

class ActivityItemDetails extends StatelessWidget {
  final bool displayUserName;
  final Activity activity;
  final Color color;

  const ActivityItemDetails(
      {super.key,
      required this.displayUserName,
      required this.activity,
      required this.color});

  Widget buildActivityDetails(
      BuildContext context,
      AppLocalizations appLocalizations,
      String formattedDate,
      String formattedTime) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${appLocalizations.date_pronoun} $formattedDate ${appLocalizations.hours_pronoun} $formattedTime',
          style: TextStyle(color: ColorUtils.greyDarker, fontFamily: 'Avenir'),
        ),
        const SizedBox(height: 8),
        buildDetailRow(
            Icons.location_on, '${activity.distance.toStringAsFixed(2)} km'),
        buildDetailRow(
            Icons.speed, '${activity.speed.toStringAsFixed(2)} km/h'),
      ],
    );
  }

  Widget buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: ColorUtils.grey, size: 16),
        const SizedBox(width: 8),
        Text(text,
            style: TextStyle(color: ColorUtils.grey, fontFamily: 'Avenir')),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('dd/MM/yyyy').format(activity.startDatetime);
    final formattedTime = DateFormat('HH:mm').format(activity.startDatetime);
    final appLocalizations = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.only(left: displayUserName ? 30 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  ActivityUtils.translateActivityTypeValue(
                    appLocalizations,
                    activity.type,
                  ).toUpperCase(),
                  style: TextStyle(
                    color: color,
                    fontFamily: 'Avenir',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
                left: displayUserName ? 30 : 0,
                bottom: displayUserName ? 30 : 0),
            child: buildActivityDetails(
                context, appLocalizations, formattedDate, formattedTime),
          ),
        ],
      ),
    );
  }
}
