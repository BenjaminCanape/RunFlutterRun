import 'package:equatable/equatable.dart';

import '../../../domain/entities/location.dart';

/// Represents a response object for a location.
class LocationResponse extends Equatable {
  /// The ID of the location.
  final String id;

  /// The datetime of the location.
  final DateTime datetime;

  /// The latitude of the location.
  final double latitude;

  /// The longitude of the location.
  final double longitude;

  /// Constructs a LocationResponse object with the given parameters.
  const LocationResponse({
    required this.id,
    required this.datetime,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [
        id,
        datetime,
        latitude,
        longitude,
      ];

  /// Creates a LocationResponse object from a JSON map.
  factory LocationResponse.fromMap(Map<String, dynamic> map) {
    return LocationResponse(
      id: map['id'].toString(),
      datetime: DateTime.parse(map['datetime']),
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Converts the LocationResponse object to a Location entity.
  Location toEntity() {
    return Location(
      id: id,
      datetime: datetime,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
