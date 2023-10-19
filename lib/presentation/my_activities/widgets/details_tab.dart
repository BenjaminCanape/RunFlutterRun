import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../domain/entities/activity.dart';
import '../../../domain/entities/enum/activity_type.dart';
import '../../common/core/utils/activity_utils.dart';
import '../../common/core/widgets/date.dart';
import '../../common/core/widgets/share_map_button.dart';
import '../../common/location/widgets/location_map.dart';
import '../../common/metrics/widgets/metrics.dart';
import '../../common/timer/widgets/timer_text.dart';
import '../view_model/activity_details_view_model.dart';

/// The tab that displays details of a specific activity.
class DetailsTab extends HookConsumerWidget {
  final Activity activity;

  const DetailsTab({Key? key, required this.activity}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(activityDetailsViewModelProvider);
    final provider = ref.read(activityDetailsViewModelProvider.notifier);

    final displayedActivity = state.activity ?? activity;
    ActivityType selectedType = state.type ?? displayedActivity.type;

    // Calculate the points for the location map.
    final List<LatLng> points = provider.savedPositionsLatLng(activity);
    final List<Marker> markers = [];

    // Add markers to the map if activity locations are available.
    if (activity.locations.isNotEmpty) {
      markers.add(
        Marker(
          width: 80.0,
          height: 80.0,
          point: LatLng(
            activity.locations.first.latitude,
            activity.locations.first.longitude,
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

      if (activity.locations.length > 1) {
        markers.add(
          Marker(
            width: 80.0,
            height: 80.0,
            point: LatLng(
              activity.locations.last.latitude,
              activity.locations.last.longitude,
            ),
            builder: (ctx) => Column(
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
      body: Column(
        children: [
          const SizedBox(height: 10),
          state.isEditing
              ? Column(children: [
                  ActivityUtils.buildActivityTypeDropdown(
                      context, selectedType, provider),
                  const SizedBox(height: 20)
                ])
              : Container(),
          Date(date: displayedActivity.startDatetime),
          Column(
            children: [
              const SizedBox(height: 30),
              Center(
                child: TimerText(timeInMs: displayedActivity.time.toInt()),
              ),
              const SizedBox(height: 15),
              Metrics(
                distance: displayedActivity.distance,
                speed: displayedActivity.speed,
              ),
            ],
          ),
          Expanded(
            child: RepaintBoundary(
              key: state.boundaryKey,
              child: LocationMap(points: points, markers: markers),
            ),
          )
        ],
      ),
      floatingActionButton: state.isEditing || state.isLoading
          ? FloatingActionButton(
              backgroundColor: Colors.teal.shade800,
              elevation: 4.0,
              onPressed: state.isLoading
                  ? null
                  : () {
                      provider.save(displayedActivity);
                    },
              child: const Icon(Icons.save),
            )
          : Stack(
              children: [
                Positioned(
                  bottom: 16,
                  right: 80,
                  child: ShareMapButton(
                      activity: displayedActivity,
                      boundaryKey: state.boundaryKey),
                ),
                Positioned(
                  bottom: 16,
                  left: 80,
                  child: FloatingActionButton(
                    backgroundColor: Colors.teal.shade800,
                    elevation: 4.0,
                    child: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
