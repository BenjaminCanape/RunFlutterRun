import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:run_flutter_run/domain/entities/enum/activity_type.dart';
import 'package:run_flutter_run/presentation/common/core/utils/activity_utils.dart';

void main() {
  group('ActivityUtils', () {
    test('getActivityTypeIcon should return correct icons', () {
      expect(ActivityUtils.getActivityTypeIcon(ActivityType.running),
          Icons.directions_run);
      expect(ActivityUtils.getActivityTypeIcon(ActivityType.walking),
          Icons.directions_walk);
      expect(ActivityUtils.getActivityTypeIcon(ActivityType.cycling),
          Icons.directions_bike);
    });
  });
}
