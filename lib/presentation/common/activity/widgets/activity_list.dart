import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:run_flutter_run/domain/entities/activity.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'activity_item.dart';

/// The screen that displays a list of activities.
class ActivityList extends HookConsumerWidget {
  /// The activities to display.
  final List<Activity> activities;

  /// Creates a [ActivityList] widget.
  ///
  /// The [activities] is the activities to display.
  const ActivityList({Key? key, required this.activities}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: activities.isEmpty
          ? Center(
              child: Text(
                AppLocalizations.of(context)!.no_data,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              itemCount: activities.length,
              itemBuilder: (context, index) {
                return ActivityItem(index: index, activity: activities[index]);
              },
            ),
    );
  }
}
