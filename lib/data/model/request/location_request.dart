import 'package:equatable/equatable.dart';

/// Represents a request object for a location.
class LocationRequest extends Equatable {
  /// The id of the location.
  final String? id;

  /// The datetime of the location.
  final DateTime datetime;

  /// The latitude of the location.
  final double latitude;

  /// The longitude of the location.
  final double longitude;

  /// Constructs a LocationRequest object with the given parameters.
  const LocationRequest({
    this.id,
    required this.datetime,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [datetime, latitude, longitude];

  /// Converts the LocationRequest object to a JSON map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'datetime': datetime.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  @override
  bool get stringify => true;
}
