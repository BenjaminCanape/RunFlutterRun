import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../data/repository/activity_repository_impl.dart';
import '../../../domain/entities/activity.dart';
import '../../activity_list/view_model/activity_list_view_model.dart';
import '../../home/screen/home_screen.dart';
import '../../home/view_model/home_view_model.dart';
import 'activitie_details_state.dart';

final activityDetailsViewModelProvider = StateNotifierProvider.autoDispose<
    ActivityDetailsViewModel,
    ActivityDetailsState>((ref) => ActivityDetailsViewModel(ref));

class ActivityDetailsViewModel extends StateNotifier<ActivityDetailsState> {
  late Ref ref;
  MapController? mapController;

  ActivityDetailsViewModel(this.ref) : super(ActivityDetailsState.initial()) {
    mapController = MapController();
  }

  void backToHome(BuildContext context) {
    Navigator.pop(context);
  }

  List<LatLng> savedPositionsLatLng(Activity activity) {
    var points = activity.locations
        .map((location) => LatLng(location.latitude, location.longitude))
        .toList();
    return points;
  }

  void removeActivity(Activity activity, BuildContext context) {
    ref
        .read(activityRepositoryProvider)
        .removeActivity(id: activity.id)
        .then((value) {
      Activity activityWithoutLocations = Activity(
          id: activity.id,
          type: activity.type,
          distance: activity.distance,
          speed: activity.speed,
          startDatetime: activity.startDatetime,
          endDatetime: activity.endDatetime,
          time: activity.time,
          locations: List.empty());

      ref
          .read(activityListViewModelProvider)
          .activities
          .remove(activityWithoutLocations);

      Navigator.pop(context);
      Navigator.pop(context);
      ref.read(homeViewModelProvider.notifier).setCurrentIndex(Tabs.list.index);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    });
  }
}
