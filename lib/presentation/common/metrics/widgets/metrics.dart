import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../view_model/metrics_view_model.dart';

/// A widget that displays the metrics information such as speed and distance.
class Metrics extends HookConsumerWidget {
  final double? speed;
  final double? distance;

  /// Creates a Metrics widget.
  const Metrics({super.key, this.speed, this.distance});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(metricsViewModelProvider);
    const textStyle = TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold);

    double speedToDisplay = state.globalSpeed;
    double distanceToDisplay = state.distance;

    if (speed != null) {
      speedToDisplay = speed!;
    }
    if (distance != null) {
      distanceToDisplay = distance!;
    }

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(children: [
            const Icon(
              Icons.location_on,
              size: 45,
            ),
            const SizedBox(width: 8),
            Column(children: [
              Text(
                distanceToDisplay.toStringAsFixed(2),
                style: textStyle,
              ),
              const Text('km'),
            ])
          ]),
          Row(children: [
            Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text(
                speedToDisplay.toStringAsFixed(2),
                style: textStyle,
              ),
              const Text('km/h'),
            ]),
            const SizedBox(width: 8),
            const Icon(
              Icons.speed,
              size: 45,
            ),
          ])
        ],
      ),
    );
  }
}
