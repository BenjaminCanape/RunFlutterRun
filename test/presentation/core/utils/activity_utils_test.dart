import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:run_flutter_run/domain/entities/enum/activity_type.dart';
import 'package:run_flutter_run/presentation/common/core/utils/activity_utils.dart';

void main() {
  group('ActivityUtils', () {
    test('getActivityTypeIcon should return correct icons', () {
      expect(ActivityUtils.getActivityTypeIcon(ActivityType.running),
          Icons.run_circle_outlined);
      expect(ActivityUtils.getActivityTypeIcon(ActivityType.walking),
          Icons.nordic_walking);
      expect(ActivityUtils.getActivityTypeIcon(ActivityType.cycling),
          Icons.pedal_bike);
    });
  });
}
