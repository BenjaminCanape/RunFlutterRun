import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/activity/widgets/activity_list.dart';
import '../../common/core/utils/ui_utils.dart';
import '../view_model/activity_list_view_model.dart';

/// The screen that displays a list of activities.
class ActivityListScreen extends HookConsumerWidget {
  const ActivityListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activities = ref.watch(activityListViewModelProvider).activities;
    final isLoading = ref.watch(activityListViewModelProvider).isLoading;

    return Scaffold(
      body: isLoading
          ? Center(child: UIUtils.loader)
          : SafeArea(
              child: Column(
                children: [ActivityList(activities: activities)],
              ),
            ),
    );
  }
}
