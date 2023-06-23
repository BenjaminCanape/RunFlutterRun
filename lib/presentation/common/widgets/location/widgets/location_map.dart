import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../utils/map_math.dart';
import '../view_model/location_view_model.dart';

class LocationMap extends HookConsumerWidget {
  final List<LatLng> points;
  final List<Marker> markers;

  const LocationMap({Key? key, required this.points, required this.markers})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(locationViewModelProvider);
    final provider = ref.read(locationViewModelProvider.notifier);

    final center = getCenterOfMap(points);
    final zoomLevel = getZoomLevel(points, center);

    return Expanded(
      child: SizedBox(
        height: 500,
        child: FlutterMap(
          mapController: provider.mapController,
          options: MapOptions(
            center: points.isNotEmpty
                ? center
                : LatLng(state.currentPosition?.latitude ?? 0,
                    state.currentPosition?.longitude ?? 0),
            zoom: zoomLevel,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            ),
            MarkerLayer(markers: markers),
            PolylineLayer(
              polylines: [
                Polyline(
                  points: points,
                  strokeWidth: 4,
                  color: Colors.blueGrey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
