import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/repositories/activity_repository_impl.dart';
import '../../../data/repositories/user_repository_impl.dart';
import '../../../domain/entities/user.dart';
import '../../../main.dart';
import '../../common/user/screens/profile_screen.dart';
import 'state/community_state.dart';

/// Provider for the community view model.
final communityViewModelProvider =
    StateNotifierProvider.autoDispose<CommunityViewModel, CommunityState>(
        (ref) => CommunityViewModel(ref));

/// View model for the community screen.
class CommunityViewModel extends StateNotifier<CommunityState> {
  late final Ref ref;

  CommunityViewModel(this.ref) : super(CommunityState.initial());

  search(String text) {
    return ref.read(userRepositoryProvider).search(text);
  }

  getMyAndMyFriendsActivities() {
    return ref.read(activityRepositoryProvider).getMyAndMyFriendsActivities();
  }

  /// Navigates to the profile of a user.
  void goToUserProfile(User user) {
    navigatorKey.currentState?.push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) =>
            SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: ProfileScreen(user: user),
        ),
      ),
    );
  }
}
