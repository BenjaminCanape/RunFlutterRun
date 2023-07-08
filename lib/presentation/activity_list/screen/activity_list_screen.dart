import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/core/widgets/loader.dart';
import '../view_model/activity_list_view_model.dart';
import '../widgets/activity_item.dart';

/// The screen that displays a list of activities.
class ActivityListScreen extends HookConsumerWidget {
  const ActivityListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activities = ref.watch(activityListViewModelProvider).activities;
    final isLoading = ref.watch(activityListViewModelProvider).isLoading;

    return Scaffold(
      body: isLoading
          ? const Center(child: loader)
          : SafeArea(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 0, top: 12),
                    child: Text(
                      AppLocalizations.of(context).activity_list,
                      style: const TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: activities.length,
                      itemBuilder: (context, index) {
                        return ActivityItem(
                            index: index, activity: activities[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
