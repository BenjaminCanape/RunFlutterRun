import 'package:equatable/equatable.dart';

import '../../../domain/entities/activity.dart';
import '../../../domain/entities/location.dart';
import '../enum/activity_type.dart';
import 'location.dart';

class ActivityResponse extends Equatable {
  final String id;
  final ActivityType type;
  final DateTime startDatetime;
  final DateTime endDatetime;
  final double distance;
  final double speed;
  final double time;

  final Iterable<LocationResponse> locations;

  const ActivityResponse(
      {required this.id,
      required this.type,
      required this.startDatetime,
      required this.endDatetime,
      required this.distance,
      required this.speed,
      required this.time,
      required this.locations});

  @override
  List<Object?> get props =>
      [id, type, startDatetime, endDatetime, distance, speed, time];

  factory ActivityResponse.fromMap(Map<String, dynamic> map) {
    ActivityType? activityType;
    if (map['type'] != null && map['type'].toString().isNotEmpty) {
      activityType = ActivityType.values.firstWhere((type) =>
          type.toString().split('.').last == map['type'].toLowerCase());
    }
    return ActivityResponse(
        id: map['id'].toString(),
        type: activityType ?? ActivityType.running,
        startDatetime: DateTime.parse(map['startDatetime']),
        endDatetime: DateTime.parse(map['endDatetime']),
        distance: map['distance'].toDouble(),
        speed:
            map['speed'] is String ? double.parse(map['speed']) : map['speed'],
        time: map['time'].toDouble(),
        locations: List<LocationResponse>.from(
            (map['locations'] as List<dynamic>)
                .map((dynamic item) => LocationResponse.fromMap(item))
                .toList()));
  }

  Activity toEntity() {
    return Activity(
        id: id,
        type: type,
        startDatetime: startDatetime,
        endDatetime: endDatetime,
        distance: distance,
        speed: speed,
        time: time,
        locations: locations
            .map((location) => Location(
                id: location.id,
                datetime: location.datetime,
                latitude: location.latitude,
                longitude: location.longitude))
            .toList());
  }
}
