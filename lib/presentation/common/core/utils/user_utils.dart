
import 'package:flutter/material.dart';

import '../../../../domain/entities/user.dart';
import '../../../../main.dart';
import '../../user/screens/profile_screen.dart';
import 'color_utils.dart';

/// Utility class for user-related operations.
class UserUtils {
  static final personIcon = Icon(
    Icons.person,
    size: 50,
    color: ColorUtils.black,
  );

  static String getNameOrUsername(User user) {
    return user.firstname != null && user.lastname != null
        ? '${user.firstname} ${user.lastname}'
        : user.username;
  }

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
