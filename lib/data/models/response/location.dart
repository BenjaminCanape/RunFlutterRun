import 'package:equatable/equatable.dart';
import 'package:run_run_run/domain/entities/location.dart';

class LocationResponse extends Equatable {
  final String id;
  final String datetime;
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
        id: map['id'] ?? '',
        datetime: map['datetime'] ?? '',
        latitude: map['latitude'] ?? '',
        longitude: map['longitude'] ?? '');
  }

  Location toEntity() {
    return Location(
        id: id, datetime: datetime, latitude: latitude, longitude: longitude);
  }
}
