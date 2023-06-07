import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:run_run_run/domain/entities/activity.dart';
import 'package:run_run_run/presentation/activity_details/view_model/activitie_details_state.dart';
import 'package:run_run_run/presentation/activity_list/view_model/activity_list_view_model.dart';

import '../../../data/repository/activity_repository_impl.dart';

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
        .then((value) => {
              ref
                  .read(activityListViewModelProvider)
                  .activities
                  .remove(activity),
              Navigator.pop(context)
            });
  }
}
