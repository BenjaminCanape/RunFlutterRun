import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../activity_list/screen/activity_list_screen.dart';
import '../../common/location/view_model/location_view_model.dart';
import '../../new_activity/screen/new_activity_screen.dart';
import '../../settings/screen/settings_screen.dart';
import '../view_model/home_view_model.dart';

/// An enumeration representing the available tabs in the home screen.
enum Tabs { home, list, settings }

/// The home screen widget.
class HomeScreen extends HookConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModelProvider);
    final homeViewModel = ref.watch(homeViewModelProvider.notifier);
    final locationViewModel = ref.read(locationViewModelProvider.notifier);
    final currentIndex = state.currentIndex;

    if (currentIndex == 0) {
      locationViewModel.startGettingLocation();
    }

    final tabs = [
      const NewActivityScreen(),
      const ActivityListScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: SafeArea(child: tabs[currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (value) {
          locationViewModel.cancelLocationStream();
          homeViewModel.setCurrentIndex(value);
        },
        showSelectedLabels: true,
        selectedItemColor: Colors.teal.shade700,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: AppLocalizations.of(context)!.activity,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.list),
            label: AppLocalizations.of(context)!.list,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: AppLocalizations.of(context)!.settings,
          ),
        ],
      ),
    );
  }
}
