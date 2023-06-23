import 'package:equatable/equatable.dart';

import '../enum/activity_type.dart';
import 'LocationRequest.dart';

class ActivityRequest extends Equatable {
  final ActivityType type;
  final DateTime startDatetime;
  final DateTime endDatetime;
  final double distance;
  final List<LocationRequest> locations;

  const ActivityRequest({
    required this.type,
    required this.startDatetime,
    required this.endDatetime,
    required this.distance,
    required this.locations,
  });

  @override
  List<Object?> get props =>
      [type, startDatetime, endDatetime, distance, locations];

  Map<String, dynamic> toMap() {
    return {
      'type': type.name.toUpperCase(),
      'startDatetime': startDatetime.toIso8601String(),
      'endDatetime': endDatetime.toIso8601String(),
      'distance': distance,
      'locations': locations.map((location) => location.toMap()).toList(),
    };
  }
}
