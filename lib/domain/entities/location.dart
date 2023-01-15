import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final String id;
  final String datetime;
  final double latitude;
  final double longitude;

  const Location(
      {required this.id,
      required this.datetime,
      required this.latitude,
      required this.longitude});

  @override
  List<Object?> get props => [id, datetime, latitude, longitude];
}
