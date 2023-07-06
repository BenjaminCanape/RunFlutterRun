import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../../domain/entities/activity.dart';
import '../../common/core/utils/activity_utils.dart';
import '../../common/core/widgets/date.dart';
import '../../common/location/widgets/location_map.dart';
import '../../common/metrics/widgets/metrics.dart';
import '../../common/timer/widgets/timer_text.dart';
import '../widgets/back_to_home_button.dart';
import '../view_model/activity_details_view_model.dart';

class ActivityDetailsScreen extends HookConsumerWidget {
  final Activity activity;

  const ActivityDetailsScreen({Key? key, required this.activity})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ignore: unused_local_variable
    final state = ref.watch(activityDetailsViewModelProvider);
    final provider = ref.read(activityDetailsViewModelProvider.notifier);

    final List<LatLng> points = provider.savedPositionsLatLng(activity);
    final List<Marker> markers = [];

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
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 25, top: 12),
              child: Row(children: [
                Icon(
                  ActivityUtils.getActivityTypeIcon(activity.type),
                  color: Colors.blueGrey,
                ),
                const SizedBox(width: 10),
                Text(
                  ActivityUtils.translateActivityTypeValue(
                    AppLocalizations.of(context),
                    activity.type,
                  ),
                  style: const TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  color: Colors.black,
                  tooltip: 'Remove',
                  onPressed: () {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.confirm,
                      title: AppLocalizations.of(context).ask_activity_removal,
                      confirmBtnText: AppLocalizations.of(context).delete,
                      cancelBtnText: AppLocalizations.of(context).cancel,
                      confirmBtnColor: Colors.red,
                      onCancelBtnTap: () => Navigator.of(context).pop(),
                      onConfirmBtnTap: () => provider.removeActivity(activity),
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
            Date(date: activity.startDatetime),
            Column(
              children: [
                const SizedBox(height: 30),
                Center(
                  child: TimerText(timeInMs: activity.time.toInt()),
                ),
                const SizedBox(height: 15),
                Metrics(
                  distance: activity.distance,
                  speed: activity.speed,
                ),
              ],
            ),
            LocationMap(points: points, markers: markers),
          ],
        ),
      ),
      floatingActionButton: const BackToHomeButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
