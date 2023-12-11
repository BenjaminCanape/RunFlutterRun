import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../domain/entities/activity.dart';
import '../../core/utils/color_utils.dart';
import '../../core/utils/type_utils.dart';
import '../view_model/activity_item_view_model.dart';
import 'activity_item.dart';

/// The screen that displays a list of activities grouped by months.
class ActivityList extends HookConsumerWidget {
  final List<Activity> activities;
  final bool displayUserName;
  final bool canOpenActivity;

  const ActivityList({
    super.key,
    this.displayUserName = false,
    this.canOpenActivity = true,
    required this.activities,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupedActivities = groupActivitiesByMonth(activities);

    useEffect(() {
      return () {
        activities.map((a) =>
            ref.read(activityItemViewModelProvider(a.id).notifier).dispose());
      };
    }, const []);

    return Expanded(
      child: groupedActivities.isEmpty
          ? Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.info, size: 48),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    AppLocalizations.of(context)!.no_data,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          : Theme(
              data: ThemeData(
                expansionTileTheme: ExpansionTileThemeData(
                  tilePadding: EdgeInsets.zero,
                  iconColor: ColorUtils.black,
                  textColor: ColorUtils.black,
                  childrenPadding: EdgeInsets.zero,
                  shape: const RoundedRectangleBorder(
                    side: BorderSide.none,
                    borderRadius: BorderRadius.zero,
                  ),
                ),
              ),
              child: ListView.builder(
                itemCount: groupedActivities.length,
                itemBuilder: (context, monthIndex) {
                  final monthActivities = groupedActivities[monthIndex];

                  return ExpansionTile(
                    tilePadding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    title: Text(
                      '${_getMonthName(monthActivities.first.startDatetime, AppLocalizations.of(context)!.localeName)} ${monthActivities.first.startDatetime.year}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    initiallyExpanded: true,
                    children: monthActivities.map((activity) {
                      return ActivityItem(
                        index: activities.indexOf(activity),
                        activity: activity,
                        displayUserName: displayUserName,
                        canOpenActivity: canOpenActivity,
                      );
                    }).toList(),
                  );
                },
              ),
            ),
    );
  }

  List<List<Activity>> groupActivitiesByMonth(List<Activity> activities) {
    final groupedActivities = <List<Activity>>[];

    if (activities.isNotEmpty) {
      activities.sort((a, b) => b.startDatetime.compareTo(a.startDatetime));

      for (var activity in activities) {
        if (groupedActivities.isEmpty ||
            groupedActivities.last.first.startDatetime.month !=
                activity.startDatetime.month) {
          groupedActivities.add([activity]);
        } else {
          groupedActivities.last.add(activity);
        }
      }
    }
    return groupedActivities;
  }

  String _getMonthName(DateTime dateTime, String locale) {
    final monthNameFormat = DateFormat('MMMM', locale);

    try {
      return monthNameFormat.format(dateTime).capitalize();
    } catch (e) {
      return '';
    }
  }
}
