import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/utils/storage_utils.dart';
import '../../../data/api/activity_api.dart';
import '../../../data/model/request/activity_request.dart';
import '../../../data/model/request/location_request.dart';
import '../../../data/repositories/activity_repository_impl.dart';
import '../../../domain/entities/activity.dart';
import '../../../domain/entities/enum/activity_type.dart';
import '../../../main.dart';
import '../../common/core/utils/activity_utils.dart';
import '../../home/screens/home_screen.dart';
import '../../home/view_model/home_view_model.dart';
import 'state/activitie_details_state.dart';

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
          likesCount: activity.likesCount,
          hasCurrentUserLiked: activity.hasCurrentUserLiked,
          locations: const [],
          user: activity.user,
          comments: activity.comments);
      ActivityUtils.updateActivity(
          ref, activityWithoutLocations, ActivityUpdateActionEnum.remove);

      navigatorKey.currentState?.pop();
      ref.read(homeViewModelProvider.notifier).setCurrentIndex(Tabs.list.index);
      navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()));
    }).catchError((error) {
      state = state.copyWith(isLoading: true);
    });
  }

  /// Sets the selected [type] of the activity.
  void setType(ActivityType type) {
    state = state.copyWith(type: type);
  }

  /// Sets the mode to edit the activity.
  editType() {
    state = state.copyWith(isEditing: true);
  }

  /// Saves the activity.
  void save(Activity activity) {
    state = state.copyWith(isEditing: false, isLoading: true);

    ref
        .read(activityRepositoryProvider)
        .editActivity(ActivityRequest(
            id: activity.id,
            type: state.type ?? activity.type,
            startDatetime: activity.startDatetime,
            endDatetime: activity.endDatetime,
            distance: activity.distance,
            locations: activity.locations
                .map((l) => LocationRequest(
                    id: l.id,
                    datetime: l.datetime,
                    latitude: l.latitude,
                    longitude: l.longitude))
                .toList()))
        .then((activityEdited) {
      StorageUtils.removeCachedDataFromUrl(
          '${ActivityApi.url}${activityEdited.id}');
      state = state.copyWith(activity: activityEdited);
      ActivityUtils.updateActivity(
          ref, activityEdited, ActivityUpdateActionEnum.edit);
    }).whenComplete(() {
      state = state.copyWith(isLoading: false);
    });
  }
}
