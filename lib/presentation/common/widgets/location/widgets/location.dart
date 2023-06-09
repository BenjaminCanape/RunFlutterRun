import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../view_model/location_view_model.dart';
import 'location_map.dart';

class Location extends HookConsumerWidget {
  const Location({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(locationViewModelProvider);
    final provider = ref.watch(locationViewModelProvider.notifier);

    var points = provider.savedPositionsLatLng();

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

    return LocationMap(points: points, markers: markers);
  }
}
