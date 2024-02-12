import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../core/utils/color_utils.dart';
import '../../core/utils/ui_utils.dart';
import '../view_model/location_view_model.dart';
import 'location_map.dart';

/// Widget that displays the current location on a map.
class CurrentLocationMap extends HookConsumerWidget {
  CurrentLocationMap({super.key});

  final dataFutureProvider = FutureProvider<void>((ref) async {
    final provider = ref.read(locationViewModelProvider.notifier);
    return await provider.startGettingLocation();
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(locationViewModelProvider.notifier);
    final state = ref.watch(locationViewModelProvider);

    var futureProvider = ref.watch(dataFutureProvider);

    final points = provider.savedPositionsLatLng();

    final currentPosition = state.currentPosition;
    final currentLatitude = currentPosition?.latitude ?? 0;
    final currentLongitude = currentPosition?.longitude ?? 0;

    final markers = <Marker>[
      Marker(
        width: 80,
        height: 80,
        point: LatLng(currentLatitude, currentLongitude),
        child: Icon(
          Icons.run_circle_sharp,
          size: 30,
          color: ColorUtils.red,
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
          child: Column(
            children: [
              IconButton(
                icon: const Icon(Icons.location_on_rounded),
                color: ColorUtils.greenDarker,
                iconSize: 35.0,
                onPressed: () {},
              ),
            ],
          ),
        ),
      );
    }

    useEffect(() {
      return () async {
        await provider.cancelLocationStream();
      };
    }, []);

    return futureProvider.when(data: (total) {
      return Expanded(
          child: LocationMap(
        points: points,
        markers: markers,
        mapController: provider.mapController ?? MapController(),
      ));
    }, loading: () {
      return Expanded(child: Center(child: UIUtils.loader));
    }, error: (error, stackTrace) {
      return Text('$error');
    });
  }
}
