import 'dart:math';

import 'package:latlong2/latlong.dart';

/// Utility class for map-related operations.
class MapUtils {
  /// Returns the center coordinates of a collection of [points].
  ///
  /// The [points] is a list of [LatLng] coordinates.
  /// Returns the center [LatLng] coordinates of the collection.
  static LatLng getCenterOfMap(List<LatLng> points) {
    double sumLat = 0.0;
    double sumLng = 0.0;

    for (LatLng coordinate in points) {
      sumLat += coordinate.latitude;
      sumLng += coordinate.longitude;
    }

    double centerLat = sumLat / points.length;
    double centerLng = sumLng / points.length;

    return LatLng(centerLat, centerLng);
  }

  /// Calculates the distance between two [LatLng] coordinates.
  ///
  /// The [point1] and [point2] are the coordinates to calculate the distance between.
  /// Returns the distance between the coordinates in meters.
  static double getDistance(LatLng point1, LatLng point2) {
    return const Distance().as(LengthUnit.Meter, point1, point2);
  }

  /// Calculates the radius of a collection of [points] around a given [center] coordinate.
  ///
  /// The [points] is a list of [LatLng] coordinates.
  /// The [center] is the coordinate around which to calculate the radius.
  /// Returns the maximum distance from the center to any point in the collection.
  static double getRadius(List<LatLng> points, LatLng center) {
    double maxDistance = 0.0;

    for (LatLng coordinate in points) {
      final distance = getDistance(center, coordinate);
      if (distance > maxDistance) {
        maxDistance = distance;
      }
    }

    return maxDistance;
  }

  /// Calculates the zoom level based on a collection of [points] and a [center] coordinate.
  ///
  /// The [points] is a list of [LatLng] coordinates.
  /// The [center] is the coordinate around which to calculate the zoom level.
  /// Returns the calculated zoom level.
  static double getZoomLevel(List<LatLng> points, LatLng center) {
    final radius = getRadius(points, center);

    double zoomLevel = 11;
    if (radius > 0) {
      final radiusElevated = radius + radius / 2;
      final scale = radiusElevated / 500;
      zoomLevel = 16 - (log(scale) / log(2));
    }
    zoomLevel = double.parse(zoomLevel.toStringAsFixed(2)) - 0.25;
    return zoomLevel;
  }
}
