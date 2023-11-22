import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../domain/entities/enum/activity_type.dart';
import '../../common/core/utils/activity_utils.dart';
import '../../common/core/utils/ui_utils.dart';
import '../../common/core/widgets/share_map_button.dart';
import '../../common/location/view_model/location_view_model.dart';
import '../../common/location/widgets/location_map.dart';
import '../../common/metrics/widgets/metrics.dart';
import '../../common/timer/widgets/timer_sized.dart';
import '../view_model/sum_up_view_model.dart';
import '../widgets/save_button.dart';

class SumUpScreen extends HookConsumerWidget {
  const SumUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sumUpViewModelProvider);
    final provider = ref.watch(sumUpViewModelProvider.notifier);
    ActivityType selectedType = state.type;

    final locations = ref.read(locationViewModelProvider).savedPositions;

    final List<LatLng> points =
        ref.read(locationViewModelProvider.notifier).savedPositionsLatLng();

    final List<Marker> markers = [];

    // Add markers to the map if activity locations are available.
    if (locations.isNotEmpty) {
      markers.add(
        Marker(
          width: 80.0,
          height: 80.0,
          point: LatLng(
            locations.first.latitude,
            locations.first.longitude,
          ),
          child: Column(
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

      if (locations.length > 1) {
        markers.add(
          Marker(
            width: 80.0,
            height: 80.0,
            point: LatLng(
              locations.last.latitude,
              locations.last.longitude,
            ),
            child: Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.location_on_rounded),
                  color: Colors.red,
                  iconSize: 35.0,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        );
      }
    }

    return Scaffold(
      body: state.isSaving
          ? const Center(child: UIUtils.loader)
          : SafeArea(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 0, top: 12),
                    child: Text(
                      AppLocalizations.of(context)!.activity_sumup,
                      style: const TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 10),
                  ActivityUtils.buildActivityTypeDropdown(
                      context, selectedType, provider),
                  const TimerTextSized(),
                  const Metrics(),
                  const SizedBox(height: 10),
                  Expanded(
                    child: RepaintBoundary(
                      key: state.boundaryKey,
                      child: LocationMap(points: points, markers: markers),
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 16,
            right: 80,
            child: SaveButton(disabled: state.isSaving),
          ),
          Positioned(
            bottom: 16,
            left: 80,
            child: ShareMapButton(
                activity: provider.getActivity(),
                boundaryKey: state.boundaryKey),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
