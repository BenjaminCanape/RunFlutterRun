import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/model/request/activity_request.dart';
import '../../../data/repositories/activity_repository_impl.dart';
import '../../../domain/entities/activity.dart';
import '../../../domain/entities/enum/activity_type.dart';
import '../../../domain/entities/location.dart';
import '../../../domain/entities/user.dart';
import '../../../main.dart';
import '../../common/core/utils/activity_utils.dart';
import '../../common/location/view_model/location_view_model.dart';
import '../../common/metrics/view_model/metrics_view_model.dart';
import '../../common/timer/viewmodel/timer_view_model.dart';
import 'state/sum_up_state.dart';

/// Provides the instance of [SumUpViewModel].
final sumUpViewModel = Provider.autoDispose((ref) {
  return SumUpViewModel(ref);
});

/// Provides the state management for the SumUpScreen.
final sumUpViewModelProvider =
    StateNotifierProvider.autoDispose<SumUpViewModel, SumUpState>(
  (ref) => SumUpViewModel(ref),
);

/// Represents the view model for the SumUpScreen.
class SumUpViewModel extends StateNotifier<SumUpState> {
  late Ref ref;

  /// Creates a new instance of [SumUpViewModel] with the given [ref].
  SumUpViewModel(this.ref) : super(SumUpState.initial());

  /// Sets the selected [type] of the activity.
  void setType(ActivityType type) {
    state = state.copyWith(type: type);
  }

  /// Saves the activity.
  void save() async {
    state = state.copyWith(isSaving: true);

    final startDatetime = ref.read(timerViewModelProvider).startDatetime;
    final endDatetime = startDatetime.add(Duration(
      hours: ref.read(timerViewModelProvider).hours,
      minutes: ref.read(timerViewModelProvider).minutes,
      seconds: ref.read(timerViewModelProvider).seconds,
    ));

    final locations = ref.read(locationViewModelProvider).savedPositions;

    ref
        .read(activityRepositoryProvider)
        .addActivity(ActivityRequest(
          type: state.type,
          startDatetime: startDatetime,
          endDatetime: endDatetime,
          distance: ref.read(metricsViewModelProvider).distance,
          locations: locations,
        ))
        .then((value) async {
      if (value != null) {
        ActivityUtils.updateActivity(ref, value, ActivityUpdateActionEnum.add);
      }
      ref.read(timerViewModelProvider.notifier).resetTimer();
      ref.read(locationViewModelProvider.notifier).resetSavedPositions();
      ref.read(metricsViewModelProvider.notifier).reset();
      ref.read(locationViewModelProvider.notifier).startGettingLocation();

      state = state.copyWith(isSaving: false);
      navigatorKey.currentState?.pop();
    });
  }

  Activity getActivity() {
    final startDatetime = ref.read(timerViewModelProvider).startDatetime;
    final endDatetime = startDatetime.add(Duration(
      hours: ref.read(timerViewModelProvider).hours,
      minutes: ref.read(timerViewModelProvider).minutes,
      seconds: ref.read(timerViewModelProvider).seconds,
    ));
    final locations = ref.read(locationViewModelProvider).savedPositions;
    final distance = ref.read(metricsViewModelProvider).distance;
    final speed = ref.read(metricsViewModelProvider).globalSpeed;

    Duration difference = endDatetime.difference(startDatetime);
    double differenceInMilliseconds = difference.inMilliseconds.toDouble();

    return Activity(
        id: '',
        type: state.type,
        startDatetime: startDatetime,
        endDatetime: endDatetime,
        distance: distance,
        speed: speed,
        time: differenceInMilliseconds,
        likesCount: 0,
        hasCurrentUserLiked: false,
        locations: locations
            .map((l) => Location(
                id: '',
                datetime: l.datetime,
                latitude: l.latitude,
                longitude: l.longitude))
            .toList(),
        user: const User(id: '', username: '', firstname: '', lastname: ''),
        comments: const []);
  }
}
