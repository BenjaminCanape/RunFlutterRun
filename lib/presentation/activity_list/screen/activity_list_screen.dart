import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../view_model/activity_list_view_model.dart';
import '../widgets/activity_item.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/back_to_home_button.dart';

class ActivityListScreen extends HookConsumerWidget {
  const ActivityListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var activities = ref.watch(activityListViewModelProvider).activities;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text(AppLocalizations.of(context).activity_list),
            Expanded(
              child: GridView.count(
                // Create a grid with 2 columns. If you change the scrollDirection to
                // horizontal, this produces 2 rows.
                crossAxisCount: 1,
                // Generate 100 widgets that display their index in the List.
                children: List.generate(activities.length, (index) {
                  return ActivityItem(activity: activities[index]);
                }),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: const BackToHomeButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 4.0,
        color: Colors.blue,
        child: IconTheme(
            data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
            child: Row(
              children: <Widget>[
                IconButton(
                  tooltip: 'Home',
                  icon: const Icon(Icons.run_circle),
                  onPressed: () {},
                ),
                const Spacer(),
              ],
            )),
      ),
    );
  }
}
