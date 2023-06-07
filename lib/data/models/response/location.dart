import 'package:equatable/equatable.dart';

import '../../../domain/entities/location.dart';

class LocationResponse extends Equatable {
  final String id;
  final DateTime datetime;
  final double latitude;
  final double longitude;

  const LocationResponse(
      {required this.id,
      required this.datetime,
      required this.latitude,
      required this.longitude});

  @override
  List<Object?> get props => [id, datetime, latitude, longitude];

  factory LocationResponse.fromMap(Map<String, dynamic> map) {
    return LocationResponse(
      id: map['id'].toString(),
      datetime: DateTime.parse(map['datetime']),
      latitude: map['latitude'] ?? '',
      longitude: map['longitude'] ?? '',
    );
  }

  Location toEntity() {
    return Location(
        id: id, datetime: datetime, latitude: latitude, longitude: longitude);
  }
}
