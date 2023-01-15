import 'package:equatable/equatable.dart';
import 'package:run_run_run/data/models/request/LocationRequest.dart';

class ActivityRequest extends Equatable {
  final String startDatetime;
  final String endDatetime;
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
      'startDatetime': startDatetime,
      'endDatetime': endDatetime,
      'distance': distance,
      'locations': locations
    };
    return queryParameters;
  }
}
