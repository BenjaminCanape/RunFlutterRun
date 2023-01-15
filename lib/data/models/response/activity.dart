import 'package:equatable/equatable.dart';
import 'package:run_run_run/data/models/response/location.dart';
import 'package:run_run_run/domain/entities/location.dart';

import '../../../domain/entities/activity.dart';

class ActivityResponse extends Equatable {
  final String id;
  final String startDatetime;
  final String endDatetime;
  final double distance;
  final double speed;
  final double time;

  final Iterable<LocationResponse> locations;

  const ActivityResponse(
      {required this.id,
      required this.startDatetime,
      required this.endDatetime,
      required this.distance,
      required this.speed,
      required this.time,
      required this.locations});

  @override
  List<Object?> get props =>
      [id, startDatetime, endDatetime, distance, speed, time];

  factory ActivityResponse.fromMap(Map<String, dynamic> map) {
    return ActivityResponse(
        id: map['id'] ?? '',
        startDatetime: map['startDatetime'] ?? '',
        endDatetime: map['endDatetime'] ?? '',
        distance: map['distance'] ?? '',
        speed: map['speed'] ?? '',
        time: map['time'] ?? '',
        locations: List<LocationResponse>.from(map['locations'] ?? []));
  }

  Activity toEntity() {
    return Activity(
        id: id,
        startDatetime: startDatetime,
        endDatetime: endDatetime,
        distance: distance,
        speed: speed,
        time: time,
        locations: locations.map((location) => Location(
            id: location.id,
            datetime: location.datetime,
            latitude: location.latitude,
            longitude: location.longitude)));
  }
}
