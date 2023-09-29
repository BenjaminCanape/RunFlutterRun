import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'profile_state.dart';

/// Provider for the profile view model.
final profileViewModelProvider =
    StateNotifierProvider.autoDispose<ProfileViewModel, ProfileState>(
        (ref) => ProfileViewModel(ref));

/// View model for the community screen.
class ProfileViewModel extends StateNotifier<ProfileState> {
  late final Ref ref;

  ProfileViewModel(this.ref) : super(ProfileState.initial()) {}
}
