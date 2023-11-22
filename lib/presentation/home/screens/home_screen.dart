import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/location/view_model/location_view_model.dart';
import '../../community/screens/community_screen.dart';
import '../../my_activities/screens/activity_list_screen.dart';
import '../../new_activity/screens/new_activity_screen.dart';
import '../../settings/screens/settings_screen.dart';
import '../view_model/home_view_model.dart';

/// An enumeration representing the available tabs in the home screen.
enum Tabs { home, list, settings }

/// The home screen widget.
class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

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
      CommunityScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
        body: SafeArea(child: tabs[currentIndex]),
        bottomNavigationBar: Container(
            color: Colors.teal.shade700,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: GNav(
                backgroundColor: Colors.teal.shade700,
                color: Colors.white,
                activeColor: Colors.white,
                tabBackgroundColor: Colors.teal.shade900,
                padding: const EdgeInsets.all(16),
                selectedIndex: currentIndex,
                onTabChange: (value) {
                  locationViewModel.cancelLocationStream();
                  homeViewModel.setCurrentIndex(value);
                },
                gap: 8,
                tabs: [
                  GButton(
                    icon: Icons.flash_on,
                    text: AppLocalizations.of(context)!.start_activity,
                  ),
                  GButton(
                    icon: Icons.list,
                    text: AppLocalizations.of(context)!.list,
                  ),
                  GButton(
                    icon: Icons.people,
                    text: AppLocalizations.of(context)!.community,
                  ),
                  GButton(
                    icon: Icons.settings,
                    text: AppLocalizations.of(context)!.settings,
                  ),
                ],
              ),
            )));
  }
}
