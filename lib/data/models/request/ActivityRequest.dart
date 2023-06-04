import 'package:equatable/equatable.dart';

import 'LocationRequest.dart';

class ActivityRequest extends Equatable {
  final DateTime startDatetime;
  final DateTime endDatetime;
  final double distance;

  final List<LocationRequest> locations;

  const ActivityRequest(
      {required this.startDatetime,
      required this.endDatetime,
      required this.distance,
      required this.locations});

  @override
  List<Object?> get props => [startDatetime, endDatetime, distance, locations];

  Map<String, dynamic> toMap() {
    final queryParameters = {
      'startDatetime': startDatetime.toIso8601String(),
      'endDatetime': endDatetime.toIso8601String(),
      'distance': distance,
      'locations': locations.map((location) => location.toMap()).toList()
    };
    return queryParameters;
  }
}
