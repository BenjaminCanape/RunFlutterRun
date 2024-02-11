import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/entities/activity.dart';
import '../../../domain/entities/page.dart';
import '../../common/activity/widgets/activity_list.dart';
import '../../common/core/enums/infinite_scroll_list.enum.dart';
import '../../common/core/utils/ui_utils.dart';
import '../view_model/activity_list_view_model.dart';

/// The screen that displays a list of activities.
class ActivityListScreen extends HookConsumerWidget {
  final activityDataFutureProvider =
      FutureProvider<EntityPage<Activity>>((ref) async {
    final provider = ref.read(activityListViewModelProvider.notifier);
    return await provider.fetchActivities();
  });

  ActivityListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(activityListViewModelProvider).isLoading;
    final provider = ref.watch(activityListViewModelProvider.notifier);

    var activityStateProvider = ref.watch(activityDataFutureProvider);

    return Scaffold(
      body: isLoading
          ? Center(child: UIUtils.loader)
          : SafeArea(
              child: Column(
                children: [
                  activityStateProvider.when(
                    data: (initialData) {
                      return ActivityList(
                        id: InfiniteScrollListEnum.myActivities.toString(),
                        activities: initialData.list,
                        total: initialData.total,
                        bottomListScrollFct: provider.fetchActivities,
                      );
                    },
                    loading: () {
                      return Expanded(child: Center(child: UIUtils.loader));
                    },
                    error: (error, stackTrace) {
                      return Text('$error');
                    },
                  )
                ],
              ),
            ),
    );
  }
}
