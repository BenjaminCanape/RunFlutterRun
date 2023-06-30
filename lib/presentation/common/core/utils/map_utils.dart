import 'dart:math';

import 'package:latlong2/latlong.dart';

class MapUtils {
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

  static double getDistance(LatLng point1, LatLng point2) {
    return const Distance().as(LengthUnit.Meter, point1, point2);
  }

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
