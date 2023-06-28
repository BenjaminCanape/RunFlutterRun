import 'package:flutter/material.dart';

import '../../../data/models/enum/activity_type.dart';
import '../../../domain/entities/activity.dart';

class UIActivityUtils {
  static IconData getActivityTypeIcon(Activity activity) {
    switch (activity.type) {
      case ActivityType.running:
        return Icons.run_circle_outlined;
      case ActivityType.walking:
        return Icons.nordic_walking;
      case ActivityType.cycling:
        return Icons.pedal_bike;
      default:
        return Icons.run_circle_rounded;
    }
  }
}
