import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../view_model/metrics_view_model.dart';

class MetricsScreen extends HookConsumerWidget {
  const MetricsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(metricsViewModelProvider);

    var textStyle = const TextStyle(fontSize: 30.0);

    return Center(
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Text('${double.parse(state.distance.toStringAsFixed(2))} Km',
          style: textStyle),
      Text('${double.parse(state.globalSpeed.toStringAsFixed(2))} Km/h',
          style: textStyle)
    ]));
  }
}
