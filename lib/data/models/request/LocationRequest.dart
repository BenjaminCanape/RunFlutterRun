import 'package:equatable/equatable.dart';

class LocationRequest extends Equatable {
  final String id;
  final String datetime;
  final double latitude;
  final double longitude;

  const LocationRequest(
      {required this.id,
      required this.datetime,
      required this.latitude,
      required this.longitude});

  @override
  List<Object?> get props => [id, datetime, latitude, longitude];
}
