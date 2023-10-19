import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:run_flutter_run/domain/entities/activity.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../core/utils/activity_utils.dart';
import '../../core/utils/color_utils.dart';
import '../../../my_activities/view_model/activity_list_view_model.dart';

class ActivityItem extends HookConsumerWidget {
  final int index;
  final Activity activity;
  final bool displayUserName;
  final bool canOpenActivity;

  const ActivityItem({
    Key? key,
    required this.activity,
    required this.index,
    this.displayUserName = false,
    this.canOpenActivity = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(activityListViewModelProvider.notifier);
    final appLocalizations = AppLocalizations.of(context)!;
    final formattedDateTime =
        DateFormat('dd/MM/yyyy ${appLocalizations.hours_pronoun} HH:mm')
            .format(activity.startDatetime);

    final List<Color> colors = ColorUtils.generateColorTupleFromIndex(index);
    final startColor = colors.first;
    final endColor = colors.last;
    const double borderRadius = 24;

    return InkWell(
      onTap: () async {
        if (canOpenActivity) {
          final activityDetails = await provider.getActivityDetails(activity);
          provider.goToActivity(activityDetails);
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: 4,
        margin: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: 120,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(borderRadius),
                  bottomLeft: Radius.circular(borderRadius),
                ),
                gradient: LinearGradient(
                  colors: [startColor, endColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: endColor,
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  ActivityUtils.getActivityTypeIcon(activity.type),
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (displayUserName)
                    Text(
                      activity.user.username,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontFamily: 'Avenir',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    ActivityUtils.translateActivityTypeValue(
                      appLocalizations,
                      activity.type,
                    ).toUpperCase(),
                    style: TextStyle(
                      color: startColor,
                      fontFamily: 'Avenir',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${appLocalizations.date_pronoun} $formattedDateTime',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontFamily: 'Avenir',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.grey.shade600,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${activity.distance.toStringAsFixed(2)} km',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontFamily: 'Avenir',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.speed,
                        color: Colors.grey.shade600,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${activity.speed.toStringAsFixed(2)} km/h',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontFamily: 'Avenir',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (canOpenActivity)
              const Icon(
                Icons.navigate_next,
                color: Colors.black,
                size: 30,
              ),
          ],
        ),
      ),
    );
  }
}
