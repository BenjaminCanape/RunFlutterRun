import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';

import '../view_model/location_view_model.dart';

class LocationScreen extends HookConsumerWidget {
  LocationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(locationViewModelProvider);
    final provider = ref.watch(locationViewModelProvider.notifier);

    final markers = <Marker>[
      Marker(
        width: 80,
        height: 80,
        point: LatLng(state.currentPosition?.latitude ?? 0,
            state.currentPosition?.longitude ?? 0),
        builder: (ctx) => const Icon(
          Icons.place,
          size: 50,
          color: Colors.red,
        ),
      ),
    ];

    return Column(children: [
      SizedBox(
          height: 500,
          child: FlutterMap(
            mapController: provider.mapController,
            options: MapOptions(
              center: LatLng(state.currentPosition?.latitude ?? 0,
                  state.currentPosition?.longitude ?? 0),
              zoom: 17,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              MarkerLayer(markers: markers),
              PolylineLayer(
                polylines: [
                  Polyline(
                      points: provider.savedPositionsLatLng(),
                      strokeWidth: 4,
                      color: Colors.red),
                ],
              ),
            ],
            nonRotatedChildren: [],
          ))
    ]);
  }
}
