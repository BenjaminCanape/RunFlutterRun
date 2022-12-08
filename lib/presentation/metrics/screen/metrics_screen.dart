import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../view_model/metrics_view_model.dart';

class MetricsScreen extends HookConsumerWidget {
  const MetricsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(metricsViewModelProvider);

    return Center(
      child: Text(
          '${double.parse(state.distance.toStringAsFixed(2))} Km - ${double.parse(state.globalSpeed.toStringAsFixed(2))} Km/h'),
    );
  }
}
