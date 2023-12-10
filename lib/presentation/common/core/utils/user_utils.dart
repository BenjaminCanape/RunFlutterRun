import 'package:flutter/material.dart';

import '../../../../domain/entities/user.dart';
import '../../../../main.dart';
import '../../user/screens/profile_screen.dart';

/// Utility class for user-related operations.
class UserUtils {
  /// Go to user profile
  static void goToProfile(User user) {
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
