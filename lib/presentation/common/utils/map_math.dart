import 'dart:math';

import 'package:latlong2/latlong.dart';

LatLng getCenterOfMap(List<LatLng> points) {
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

double getDistance(LatLng point1, LatLng point2) {
  return const Distance().as(LengthUnit.Meter, point1, point2);
}

double getRadius(List<LatLng> points, LatLng center) {
  double maxDistance = 0.0;

  for (LatLng coordinate in points) {
    double distance = getDistance(center, coordinate);
    if (distance > maxDistance) {
      maxDistance = distance;
    }
  }

  return maxDistance;
}

double getZoomLevel(List<LatLng> points, LatLng center) {
  var radius = getRadius(points, center);

  double zoomLevel = 11;
  if (radius > 0) {
    double radiusElevated = radius + radius / 2;
    double scale = radiusElevated / 500;
    zoomLevel = 16 - (log(scale) / log(2));
  }
  zoomLevel = num.parse(zoomLevel.toStringAsFixed(2)).toDouble();
  return zoomLevel;
}
