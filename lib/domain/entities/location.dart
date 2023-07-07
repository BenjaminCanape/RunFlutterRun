import 'package:equatable/equatable.dart';

/// Represents a location.
class Location extends Equatable {
  /// The ID of the location.
  final String id;

  /// The datetime of the location.
  final DateTime datetime;

  /// The latitude of the location.
  final double latitude;

  /// The longitude of the location.
  final double longitude;

  /// Constructs a Location object with the given parameters.
  const Location({
    required this.id,
    required this.datetime,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [id, datetime, latitude, longitude];
}
