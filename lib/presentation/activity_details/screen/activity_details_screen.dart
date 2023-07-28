import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../../domain/entities/activity.dart';
import '../../../domain/entities/enum/activity_type.dart';
import '../../common/core/utils/activity_utils.dart';
import '../../common/core/utils/ui_utils.dart';
import '../../common/core/widgets/date.dart';
import '../../common/location/widgets/location_map.dart';
import '../../common/metrics/widgets/metrics.dart';
import '../../common/timer/widgets/timer_text.dart';
import '../view_model/activity_details_view_model.dart';

/// The screen that displays details of a specific activity.
class ActivityDetailsScreen extends HookConsumerWidget {
  final Activity activity;

  const ActivityDetailsScreen({Key? key, required this.activity})
      : super(key: key);

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

    Widget buildScreenshot(List<LatLng> points, List<Marker> markers) {
      return RepaintBoundary(
        key: state.boundaryKey,
        child: LocationMap(points: points, markers: markers),
      );
    }

    Widget floatingActionButtonScreenshot() {
      return SizedBox(
          height: 500, width: 500, child: buildScreenshot(points, markers));
    }

    return Scaffold(
      body: state.isLoading
          ? const Center(child: UIUtils.loader)
          : SafeArea(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 25, top: 12),
                    child: Row(children: [
                      Icon(
                        ActivityUtils.getActivityTypeIcon(
                            displayedActivity.type),
                        color: Colors.blueGrey,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        ActivityUtils.translateActivityTypeValue(
                          AppLocalizations.of(context),
                          displayedActivity.type,
                        ),
                        style: const TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      IconButton(
                        color: Colors.black,
                        tooltip: 'Edit',
                        onPressed: () => provider.editType(),
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.blueGrey,
                        ),
                      ),
                      IconButton(
                        color: Colors.black,
                        tooltip: 'Remove',
                        onPressed: () {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.confirm,
                            title: AppLocalizations.of(context)
                                .ask_activity_removal,
                            confirmBtnText: AppLocalizations.of(context).delete,
                            cancelBtnText: AppLocalizations.of(context).cancel,
                            confirmBtnColor: Colors.red,
                            onCancelBtnTap: () => Navigator.of(context).pop(),
                            onConfirmBtnTap: () =>
                                provider.removeActivity(displayedActivity),
                          );
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      )
                    ]),
                  ),
                  const Divider(),
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
                        child:
                            TimerText(timeInMs: displayedActivity.time.toInt()),
                      ),
                      const SizedBox(height: 15),
                      Metrics(
                        distance: displayedActivity.distance,
                        speed: displayedActivity.speed,
                      ),
                    ],
                  ),
                  Expanded(
                    child: buildScreenshot(points, markers),
                  )
                ],
              ),
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
                  child: FloatingActionButton(
                    onPressed: () => provider.shareMap(
                        context, floatingActionButtonScreenshot()),
                    backgroundColor: Colors.teal.shade800,
                    elevation: 4.0,
                    child: const Icon(Icons.share),
                  ),
                ),
                const Positioned(
                  bottom: 16,
                  left: 80,
                  child: BackButton(),
                ),
              ],
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
