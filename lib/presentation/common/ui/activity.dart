import 'package:flutter/material.dart';
import 'package:run_flutter_run/domain/entities/activity.dart';

import '../../../data/models/enum/activity_type.dart';

IconData getActivityTypeIcon(Activity activity) {
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
