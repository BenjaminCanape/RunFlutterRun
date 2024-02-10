import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../core/utils/color_utils.dart';
import '../../core/utils/map_utils.dart';
import '../view_model/location_view_model.dart';

/// Widget that displays a map with markers and polylines representing locations.
class LocationMap extends HookConsumerWidget {
  final List<LatLng> points;
  final List<Marker> markers;

  const LocationMap({super.key, required this.points, required this.markers});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(locationViewModelProvider.notifier);
    final state = ref.watch(locationViewModelProvider);

    final center = MapUtils.getCenterOfMap(points);
    final zoomLevel = MapUtils.getZoomLevel(points, center);

    return SizedBox(
      height: 500,
      child: FlutterMap(
        mapController: provider.mapController,
        options: MapOptions(
          initialCenter: points.isNotEmpty
              ? center
              : LatLng(state.currentPosition?.latitude ?? 0,
                  state.currentPosition?.longitude ?? 0),
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
