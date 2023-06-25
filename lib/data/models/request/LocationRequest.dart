import 'package:equatable/equatable.dart';

class LocationRequest extends Equatable {
  final DateTime datetime;
  final double latitude;
  final double longitude;

  const LocationRequest({
    required this.datetime,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [datetime, latitude, longitude];

  Map<String, dynamic> toMap() {
    return {
      'datetime': datetime.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
