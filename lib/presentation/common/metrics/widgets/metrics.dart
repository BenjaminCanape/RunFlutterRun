import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../view_model/metrics_view_model.dart';

/// A widget that displays the metrics information such as speed and distance.
class Metrics extends HookConsumerWidget {
  final double? speed;
  final double? distance;

  /// Creates a Metrics widget.
  const Metrics({Key? key, this.speed, this.distance}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(metricsViewModelProvider);
    const textStyle = TextStyle(fontSize: 30.0);

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
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Icon(Icons.location_on),
          const SizedBox(width: 8),
          Text(
            '${distanceToDisplay.toStringAsFixed(2)} km',
            style: textStyle,
          ),
          const SizedBox(width: 40),
          const Icon(Icons.speed),
          const SizedBox(width: 8),
          Text(
            '${speedToDisplay.toStringAsFixed(2)} km/h',
            style: textStyle,
          ),
        ],
      ),
    );
  }
}
