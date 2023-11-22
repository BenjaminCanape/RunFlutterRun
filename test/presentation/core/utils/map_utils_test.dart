import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:run_flutter_run/presentation/common/core/utils/map_utils.dart';

void main() {
  group('MapUtils', () {
    test('getCenterOfMap should return the center coordinates', () {
      final points = [
        const LatLng(48.8566, 2.3522), // Paris
        const LatLng(45.75, 4.85), // Lyon
        const LatLng(43.2965, 5.3698), // Marseille
      ];

      final center = MapUtils.getCenterOfMap(points);

      expect(center.latitude, closeTo(45.9677, 0.0001));
      expect(center.longitude, closeTo(4.190666666666666, 0.0001));
    });

    test('getDistance should return the distance between two coordinates', () {
      const point1 = LatLng(48.8566, 2.3522); // Paris
      const point2 = LatLng(45.7579, 4.8357); // Lyon

      final distance = MapUtils.getDistance(point1, point2);

      expect(distance, closeTo(392313.0, 10));
    });

    test(
        'getRadius should return the maximum distance from the center to any point',
        () {
      final points = [
        const LatLng(48.8566, 2.3522), // Paris
        const LatLng(45.75, 4.85), // Lyon
        const LatLng(43.2965, 5.3698), // Marseille
      ];
      const center = LatLng(45.9677,
          4.190666666666666); // Center between Paris, Lyon, and Marseille

      final radius = MapUtils.getRadius(points, center);

      expect(radius, closeTo(349844.0, 0.001));
    });

    test('getZoomLevel should return the calculated zoom level', () {
      final points = [
        const LatLng(48.8566, 2.3522), // Paris
        const LatLng(45.75, 4.85), // Lyon
        const LatLng(43.2965, 5.3698), // Marseille
      ];
      const center = LatLng(45.9677,
          4.190666666666666); // Center between Paris, Lyon, and Marseille

      final zoomLevel = MapUtils.getZoomLevel(points, center);

      expect(zoomLevel, closeTo(5.71, 0.01));
    });
  });
}
