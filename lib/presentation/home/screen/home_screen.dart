import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../activity_list/screen/activity_list_screen.dart';
import '../../new_activity/screen/new_activity_screen.dart';
import '../../settings/screen/settings_screen.dart';
import '../view_model/home_view_model.dart';

enum Tabs { home, list }

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var state = ref.watch(homeViewModelProvider);
    // ignore: unused_local_variable
    var provider = ref.watch(homeViewModelProvider.notifier);
    int currentIndex = state.currentIndex;

    List<Widget> tabs = [
      const NewActivityScreen(),
      const ActivityListScreen(),
      const SettingsScreen()
    ];

    return Scaffold(
        body: SafeArea(child: tabs[currentIndex]),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (value) =>
              ref.read(homeViewModelProvider.notifier).setCurrentIndex(value),
          showSelectedLabels: false,
          selectedItemColor: Colors.teal.shade700,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'List'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Settings')
          ],
        ));
  }
}
