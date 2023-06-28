import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../view_model/metrics_view_model.dart';

class Metrics extends HookConsumerWidget {
  final double? speed;
  final double? distance;

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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            '${distanceToDisplay.toStringAsFixed(2)} Km',
            style: textStyle,
          ),
          Text(
            '${speedToDisplay.toStringAsFixed(2)} Km/h',
            style: textStyle,
          ),
        ],
      ),
    );
  }
}
