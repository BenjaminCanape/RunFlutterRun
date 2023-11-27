import 'dart:typed_data';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../data/repositories/user_repository_impl.dart';
import 'state/activity_item_state.dart';

/// Provider for the activity item view model.
final activityItemViewModelProvider =
    StateNotifierProvider.autoDispose<ActivityItemViewModel, ActivityItemState>(
        (ref) => ActivityItemViewModel(ref));

/// View model for the activity item widget.
class ActivityItemViewModel extends StateNotifier<ActivityItemState> {
  late final Ref ref;

  ActivityItemViewModel(this.ref) : super(ActivityItemState.initial());

  Future<Uint8List?> getProfilePicture(String userId) async {
    return ref.read(userRepositoryProvider).downloadProfilePicture(userId);
  }
}
