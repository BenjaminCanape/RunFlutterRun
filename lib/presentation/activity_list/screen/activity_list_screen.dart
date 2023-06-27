import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../view_model/activity_list_view_model.dart';
import '../widgets/activity_item.dart';

class ActivityListScreen extends HookConsumerWidget {
  const ActivityListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var activities = ref.watch(activityListViewModelProvider).activities;
    var isLoading = ref.watch(activityListViewModelProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 40,
        leading: const Icon(
          Icons.list,
          color: Colors.grey,
        ),
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
          color: Colors.grey.shade800,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        title: Text(
          AppLocalizations.of(context).activity_list.toUpperCase(),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: activities.length,
                      itemBuilder: (context, index) {
                        return ActivityItem(activity: activities[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
