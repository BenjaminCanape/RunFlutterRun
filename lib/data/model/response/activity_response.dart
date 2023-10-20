import 'package:equatable/equatable.dart';
import 'user_response.dart';

import '../../../domain/entities/activity.dart';
import '../../../domain/entities/enum/activity_type.dart';
import '../../../domain/entities/location.dart';
import '../../../domain/entities/user.dart';
import 'location_response.dart';

/// Represents a response object for an activity.
class ActivityResponse extends Equatable {
  /// The ID of the activity.
  final String id;

  /// The type of the activity.
  final ActivityType type;

  /// The start datetime of the activity.
  final DateTime startDatetime;

  /// The end datetime of the activity.
  final DateTime endDatetime;

  /// The distance covered in the activity.
  final double distance;

  /// The average speed in the activity.
  final double speed;

  /// The total time of the activity.
  final double time;

  /// The list of locations associated with the activity.
  final Iterable<LocationResponse> locations;

  /// The user concerned by the activity
  final UserResponse user;

  /// Constructs an ActivityResponse object with the given parameters.
  const ActivityResponse(
      {required this.id,
      required this.type,
      required this.startDatetime,
      required this.endDatetime,
      required this.distance,
      required this.speed,
      required this.time,
      required this.locations,
      required this.user});

  @override
  List<Object?> get props => [
        id,
        type,
        startDatetime,
        endDatetime,
        distance,
        speed,
        time,
        ...locations,
        user
      ];

  /// Creates an ActivityResponse object from a JSON map.
  factory ActivityResponse.fromMap(Map<String, dynamic> map) {
    final activityTypeString = map['type']?.toString().toLowerCase();
    final activityType = ActivityType.values.firstWhere(
      (type) => type.name.toLowerCase() == activityTypeString,
      orElse: () => ActivityType.running,
    );

    return ActivityResponse(
        id: map['id'].toString(),
        type: activityType,
        startDatetime: DateTime.parse(map['startDatetime']),
        endDatetime: DateTime.parse(map['endDatetime']),
        distance: map['distance'].toDouble(),
        speed: map['speed'] is String
            ? double.parse(map['speed'])
            : map['speed'].toDouble(),
        time: map['time'].toDouble(),
        locations: (map['locations'] as List<dynamic>)
            .map<LocationResponse>((item) => LocationResponse.fromMap(item))
            .toList(),
        user: UserResponse.fromMap(map['user']));
  }

  /// Converts the ActivityResponse object to an Activity entity.
  Activity toEntity() {
    final activityLocations = locations.map<Location>((location) {
      return Location(
        id: location.id,
        datetime: location.datetime,
        latitude: location.latitude,
        longitude: location.longitude,
      );
    }).toList()
      ..sort((a, b) => a.datetime.compareTo(b.datetime));

    return Activity(
        id: id,
        type: type,
        startDatetime: startDatetime,
        endDatetime: endDatetime,
        distance: distance,
        speed: speed,
        time: time,
        locations: activityLocations,
        user: User(id: user.id, username: user.username));
  }
}
