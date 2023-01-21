import 'package:equatable/equatable.dart';
import 'package:run_run_run/data/models/request/LocationRequest.dart';

class ActivityRequest extends Equatable {
  final DateTime startDatetime;
  final DateTime endDatetime;
  final double distance;

  final Iterable<LocationRequest> locations;

  const ActivityRequest(
      {required this.startDatetime,
      required this.endDatetime,
      required this.distance,
      required this.locations});

  @override
  List<Object?> get props => [startDatetime, endDatetime, distance];

  Map<String, dynamic> toMap() {
    final queryParameters = {
      'startDatetime': startDatetime.toIso8601String(),
      'endDatetime': endDatetime.toIso8601String(),
      'distance': distance,
      'locations': []
    };
    return queryParameters;
  }
}
