import 'package:equatable/equatable.dart';

import '../../data/models/enum/activity_type.dart';
import 'location.dart';

class Activity extends Equatable {
  final String id;
  final ActivityType type;
  final DateTime startDatetime;
  final DateTime endDatetime;
  final double distance;
  final double speed;
  final double time;

  final Iterable<Location> locations;

  const Activity({
    required this.id,
    required this.type,
    required this.startDatetime,
    required this.endDatetime,
    required this.distance,
    required this.speed,
    required this.time,
    required this.locations,
  });

  @override
  List<Object?> get props =>
      [id, type, startDatetime, endDatetime, distance, speed, time];
}
