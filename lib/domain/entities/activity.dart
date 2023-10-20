import 'package:equatable/equatable.dart';
import 'user.dart';

import 'enum/activity_type.dart';
import 'location.dart';

/// Represents an activity.
class Activity extends Equatable {
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
  final Iterable<Location> locations;

  // The user concerned by the activity
  final User user;

  /// Constructs an Activity object with the given parameters.
  const Activity(
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
}
