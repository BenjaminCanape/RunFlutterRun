import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/activity.dart';

class ActivityItem extends HookConsumerWidget {
  final Activity activity;
  const ActivityItem({Key? key, required this.activity}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(children: [
      Text(
        'Le ${DateFormat('dd/MM/yyyy à kk:mm').format(activity.startDatetime)}:',
      ),
      Text(
        'Distance: ${activity.distance.toStringAsFixed(2)} km  - Vitesse: ${activity.speed.toStringAsFixed(2)} km/h',
      )
    ]);
  }
}
