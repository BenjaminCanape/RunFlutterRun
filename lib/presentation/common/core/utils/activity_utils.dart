import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/utils/storage_utils.dart';
import '../../../../domain/entities/activity.dart';
import '../../../../domain/entities/enum/activity_type.dart';
import '../../../../domain/entities/user.dart';
import '../../../my_activities/view_model/activity_details_view_model.dart';
import '../../../new_activity/view_model/sum_up_view_model.dart';
import '../enums/infinite_scroll_list.enum.dart';
import '../widgets/view_model/infinite_scroll_list_view_model.dart';

/// Utility class for activity-related operations.
class ActivityUtils {
  /// Returns the icon associated with the given activity type.
  ///
  /// Returns [Icons.run_circle_outlined] for [ActivityType.running],
  /// [Icons.nordic_walking] for [ActivityType.walking],
  /// [Icons.pedal_bike] for [ActivityType.cycling], and
  /// [Icons.run_circle_rounded] for any other activity type.
  static IconData getActivityTypeIcon(ActivityType type) {
    switch (type) {
      case ActivityType.running:
        return Icons.run_circle_outlined;
      case ActivityType.walking:
        return Icons.nordic_walking;
      case ActivityType.cycling:
        return Icons.pedal_bike;
      default:
        return Icons.run_circle_rounded;
    }
  }

  /// Translates the name of the activity type using the provided localization.
  ///
  /// The [localization] is used to translate the activity type name.
  static String translateActivityTypeValue(
      AppLocalizations localization, ActivityType type) {
    return type.getTranslatedName(localization);
  }

  /// Builds the dropdown button for selecting the activity type.
  static Widget buildActivityTypeDropdown<T>(
    BuildContext context,
    ActivityType selectedType,
    T provider,
  ) {
    List<DropdownMenuItem<ActivityType>> dropdownItems = ActivityType.values
        .map((ActivityType value) => DropdownMenuItem<ActivityType>(
              value: value,
              child: Row(children: [
                Icon(ActivityUtils.getActivityTypeIcon(value)),
                const SizedBox(width: 10),
                Text(
                  ActivityUtils.translateActivityTypeValue(
                    AppLocalizations.of(context)!,
                    value,
                  ),
                )
              ]),
            ))
        .toList();

    return DropdownButton<ActivityType>(
      value: selectedType,
      items: dropdownItems,
      onChanged: (ActivityType? newValue) {
        if (newValue != null && provider is ActivityDetailsViewModel) {
          provider.setType(newValue);
        } else if (newValue != null && provider is SumUpViewModel) {
          provider.setType(newValue);
        }
      },
    );
  }

  static List<List<Activity>> replaceActivity(
      List<List<Activity>> activities, Activity updatedActivity) {
    return activities.map((innerList) {
      return innerList.map((activity) {
        if (activity.id == updatedActivity.id) {
          return updatedActivity;
        } else {
          return activity;
        }
      }).toList();
    }).toList();
  }

  static List<List<Activity>> deleteActivity(
      List<List<Activity>> activities, Activity activityToDelete) {
    return activities
        .where((innerList) =>
            innerList.any((activity) => activity.id != activityToDelete.id))
        .toList();
  }

  static List<List<Activity>> prependActivity(
      List<List<Activity>> activities, Activity activity) {
    bool addNewGroup = !(activity.startDatetime.month ==
            activities.first.first.startDatetime.month &&
        activity.startDatetime.year ==
            activities.first.first.startDatetime.year);

    if (addNewGroup) {
      activities.insert(0, [activity]);
    } else {
      activities.first.insert(0, activity);
    }

    return activities;
  }

  static Future<void> updateActivity(
      Ref<Object?> ref, Activity updatedActivity, String action) async {
    await _updateActivityList(
        ref,
        InfiniteScrollListEnum.myActivities.toString(),
        updatedActivity,
        action);
    await _updateActivityList(ref, InfiniteScrollListEnum.community.toString(),
        updatedActivity, action);

    User? currentUser = await StorageUtils.getUser();
    if (currentUser != null) {
      await _updateActivityList(
          ref,
          '${InfiniteScrollListEnum.profile}_${currentUser.id}',
          updatedActivity,
          action);
    }
  }

  static Future<void> _updateActivityList(Ref<Object?> ref, String listType,
      Activity updatedActivity, String action) async {
    var data = ref.read(infiniteScrollListViewModelProvider(listType)).data;

    List<List<Activity>> newData = [];

    if (action == 'edit') {
      newData = ActivityUtils.replaceActivity(
          data as List<List<Activity>>, updatedActivity);
    } else if (action == 'remove') {
      newData = ActivityUtils.deleteActivity(
          data as List<List<Activity>>, updatedActivity);
    } else if (action == 'add') {
      newData = ActivityUtils.prependActivity(
          data as List<List<Activity>>, updatedActivity);
    }

    ref
        .read(infiniteScrollListViewModelProvider(listType).notifier)
        .replaceData(newData);
  }
}
