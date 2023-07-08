import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../data/repositories/activity_repository_impl.dart';
import '../../../domain/entities/activity.dart';
import '../../../main.dart';
import '../../activity_list/view_model/activity_list_view_model.dart';
import '../../home/screen/home_screen.dart';
import '../../home/view_model/home_view_model.dart';
import 'activitie_details_state.dart';

/// Provider for the activity details view model.
final activityDetailsViewModelProvider = StateNotifierProvider.autoDispose<
    ActivityDetailsViewModel,
    ActivityDetailsState>((ref) => ActivityDetailsViewModel(ref));

/// View model for the activity details screen.
class ActivityDetailsViewModel extends StateNotifier<ActivityDetailsState> {
  late final Ref ref;
  MapController? mapController;

  ActivityDetailsViewModel(this.ref) : super(ActivityDetailsState.initial()) {
    mapController = MapController();
  }

  /// Navigates back to the home screen.
  void backToHome() {
    navigatorKey.currentState?.pop();
  }

  /// Converts the saved locations of the activity to a list of LatLng points.
  List<LatLng> savedPositionsLatLng(Activity activity) {
    final points = activity.locations
        .map((location) => LatLng(location.latitude, location.longitude))
        .toList();
    return points;
  }

  /// Removes the specified activity.
  void removeActivity(Activity activity) {
    state = state.copyWith(isLoading: true);
    ref
        .read(activityRepositoryProvider)
        .removeActivity(id: activity.id)
        .then((value) {
      final activityWithoutLocations = Activity(
        id: activity.id,
        type: activity.type,
        distance: activity.distance,
        speed: activity.speed,
        startDatetime: activity.startDatetime,
        endDatetime: activity.endDatetime,
        time: activity.time,
        locations: const [],
      );

      ref
          .read(activityListViewModelProvider)
          .activities
          .remove(activityWithoutLocations);

      navigatorKey.currentState?.pop();
      navigatorKey.currentState?.pop();
      ref.read(homeViewModelProvider.notifier).setCurrentIndex(Tabs.list.index);
      navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()));
    }).catchError((error) {
      state = state.copyWith(isLoading: true);
    });
  }
}
