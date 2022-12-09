import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../view_model/location_view_model.dart';

class LocationScreen extends HookConsumerWidget {
  const LocationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(locationViewModelProvider);

    return Center(
        child: Column(children: [
      Text('Voici votre position:'),
      Text(
          'Latitude: ${state.currentPosition != null ? state.currentPosition?.latitude.toString() : '0'},'
          ' Longitude: ${state.currentPosition != null ? state.currentPosition?.longitude.toString() : '0'}'),
    ]));
  }
}
