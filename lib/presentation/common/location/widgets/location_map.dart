import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../core/utils/color_utils.dart';
import '../../core/utils/map_utils.dart';

/// Widget that displays a map with markers and polylines representing locations.
class LocationMap extends HookConsumerWidget {
  final List<LatLng> points;
  final List<Marker> markers;
  final MapController mapController;

  const LocationMap(
      {super.key,
      required this.points,
      required this.markers,
      required this.mapController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final center = MapUtils.getCenterOfMap(points);
    final zoomLevel = MapUtils.getZoomLevel(points, center);

    return SizedBox(
      height: 500,
      child: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: points.isNotEmpty ? center : const LatLng(0, 0),
          initialZoom: zoomLevel,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          PolylineLayer(
            polylines: [
              Polyline(
                  points: points, strokeWidth: 4, color: ColorUtils.blueGrey),
            ],
          ),
          MarkerLayer(markers: markers),
        ],
      ),
    );
  }
}
