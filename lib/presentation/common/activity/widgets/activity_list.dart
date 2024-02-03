import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../domain/entities/activity.dart';
import '../../../../domain/entities/page.dart';
import '../../core/utils/color_utils.dart';
import '../../core/utils/type_utils.dart';
import '../../core/widgets/infinite_scroll_list.dart';
import '../view_model/activity_list_view_model.dart';
import 'activity_item.dart';

class ActivityList extends HookConsumerWidget {
  final String id;
  final List<Activity> activities;
  final int total;
  final bool displayUserName;
  final bool canOpenActivity;
  final Future<EntityPage<Activity>> Function({int pageNumber})
      bottomListScrollFct;

  const ActivityList(
      {super.key,
      this.displayUserName = false,
      this.canOpenActivity = true,
      required this.id,
      required this.activities,
      required this.bottomListScrollFct,
      required this.total});

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider =
        ref.watch(activityListWidgetViewModelProvider(id).notifier);
    final state = ref.watch(activityListWidgetViewModelProvider(id));
    var groupedActivities = state.groupedActivities.isNotEmpty
        ? state.groupedActivities
        : groupActivitiesByMonth(activities);

    return Expanded(
        child: InfiniteScrollList(
      listId: id,
      initialData: groupedActivities,
      total: total,
      loadData: (int pageNumber) async {
        final newPage = await bottomListScrollFct(pageNumber: pageNumber);

        final newGrouped = groupActivitiesByMonth(newPage.list);

        for (var newGroup in newGrouped) {
          final newGroupMonth = newGroup.first.startDatetime.month;

          final existingGroupIndex = groupedActivities.indexWhere(
            (existingGroup) =>
                existingGroup.first.startDatetime.month == newGroupMonth,
          );

          if (existingGroupIndex != -1) {
            groupedActivities[existingGroupIndex].removeWhere(
              (existingActivity) => newGroup
                  .any((newActivity) => existingActivity.id == newActivity.id),
            );
            groupedActivities[existingGroupIndex].addAll(newGroup);
          } else {
            groupedActivities.add(newGroup);
          }
        }

        return EntityPage<List<Activity>>(
          list: groupedActivities,
          total: newPage.total,
        );
      },
      hasMoreData: provider.hasMoreData,
      itemBuildFunction: (context, groupedActivities, monthIndex) {
        final monthActivities = groupedActivities[monthIndex];
        int previousMonthsTotal = 0;
        for (int i = 0; i < monthIndex; i++) {
          previousMonthsTotal += groupedActivities[i].length as int;
        }

        return Expanded(
            child: Theme(
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
                child: ExpansionTile(
                    tilePadding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    title: Text(
                      '${_getMonthName(monthActivities.first.startDatetime, AppLocalizations.of(context)!.localeName)} ${monthActivities.first.startDatetime.year}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    initiallyExpanded: true,
                    children:
                        monthActivities.asMap().entries.map<Widget>((entry) {
                      final index = previousMonthsTotal + entry.key;
                      final activity = entry.value;
                      return ActivityItem(
                        index: index as int,
                        activity: activity,
                        displayUserName: displayUserName,
                        canOpenActivity: canOpenActivity,
                      );
                    }).toList())));
      },
    ));
  }
}
