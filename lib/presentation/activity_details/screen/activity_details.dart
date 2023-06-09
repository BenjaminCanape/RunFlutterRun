import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../domain/entities/activity.dart';
import '../../common/widgets/buttons/back_to_home_button.dart';
import '../../common/widgets/date/date.dart';
import '../../common/widgets/location/widgets/location_map.dart';
import '../../common/widgets/metrics/widgets/metrics.dart';
import '../../common/widgets/timer/widgets/timer_text.dart';
import '../view_model/activity_details_view_model.dart';
import '../widgets/remove_alert.dart';

class ActivityDetails extends HookConsumerWidget {
  final Activity activity;
  const ActivityDetails({Key? key, required this.activity}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ignore: unused_local_variable
    final state = ref.watch(activityDetailsViewModelProvider);
    final provider = ref.read(activityDetailsViewModelProvider.notifier);

    List<LatLng> points = provider.savedPositionsLatLng(activity);
    List<Marker> markers = [];

    if (activity.locations.isNotEmpty) {
      markers.add(Marker(
          width: 80.0,
          height: 80.0,
          point: LatLng(activity.locations.first.latitude,
              activity.locations.first.longitude),
          builder: (ctx) => Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.location_on),
                    color: Colors.green.shade700,
                    iconSize: 40.0,
                    onPressed: () {},
                  ),
                  Text(AppLocalizations.of(context).start,
                      style: const TextStyle(fontWeight: FontWeight.bold))
                ],
              )));

      if (activity.locations.length > 1) {
        markers.add(Marker(
            width: 80.0,
            height: 80.0,
            point: LatLng(activity.locations.last.latitude,
                activity.locations.last.longitude),
            builder: (ctx) => Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.location_on),
                      color: Colors.red,
                      iconSize: 40.0,
                      onPressed: () {},
                    ),
                    Text(
                      AppLocalizations.of(context).end,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                )));
      }
    }

    return Scaffold(
      appBar: AppBar(
          leadingWidth: 40,
          leading: const Icon(
            Icons.run_circle_outlined,
            color: Colors.grey,
          ),
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
              color: Colors.grey.shade800,
              fontSize: 22,
              fontWeight: FontWeight.bold),
          title: Row(
            children: [
              Text(
                AppLocalizations.of(context).running.toUpperCase(),
              ),
              const Spacer(),
              IconButton(
                  color: Colors.black,
                  tooltip: 'Remove',
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return RemoveAlert(activity: activity);
                        });
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  )),
            ],
          )),
      body: SafeArea(
        child: Column(
          children: [
            Card(
              child: ListTile(
                subtitle: Column(children: [
                  Date(date: activity.startDatetime),
                  Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: TimerText(timeInMs: activity.time.toInt()),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Metrics(
                          distance: activity.distance, speed: activity.speed),
                    ],
                  )
                ]),
              ),
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
