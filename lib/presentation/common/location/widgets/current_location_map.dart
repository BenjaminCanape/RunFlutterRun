import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../view_model/location_view_model.dart';
import 'location_map.dart';

/// Widget that displays the current location on a map.
class CurrentLocationMap extends HookConsumerWidget {
  const CurrentLocationMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(locationViewModelProvider);
    final provider = ref.read(locationViewModelProvider.notifier);

    final points = provider.savedPositionsLatLng();

    final currentPosition = state.currentPosition;
    final currentLatitude = currentPosition?.latitude ?? 0;
    final currentLongitude = currentPosition?.longitude ?? 0;

    final markers = <Marker>[
      Marker(
        width: 80,
        height: 80,
        point: LatLng(currentLatitude, currentLongitude),
        builder: (ctx) => const Icon(
          Icons.run_circle_sharp,
          size: 30,
          color: Colors.red,
        ),
      ),
    ];

    if (points.isNotEmpty) {
      markers.add(
        Marker(
          width: 80.0,
          height: 80.0,
          point: LatLng(
            points.first.latitude,
            points.first.longitude,
          ),
          builder: (ctx) => Column(
            children: [
              IconButton(
                icon: const Icon(Icons.location_on_rounded),
                color: Colors.green.shade700,
                iconSize: 35.0,
                onPressed: () {},
              ),
            ],
          ),
        ),
      );
    }

    return LocationMap(points: points, markers: markers);
  }
}
