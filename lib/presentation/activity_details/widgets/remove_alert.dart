import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:run_run_run/domain/entities/activity.dart';

import '../view_model/activity_details_view_model.dart';

class RemoveAlert extends HookConsumerWidget {
  final Activity activity;

  const RemoveAlert({Key? key, required this.activity}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ignore: unused_local_variable
    final state = ref.watch(activityDetailsViewModelProvider);
    final provider = ref.read(activityDetailsViewModelProvider.notifier);

    return AlertDialog(title: Text("Confirmer la suppression"), actions: [
      TextButton(
          onPressed: () => provider.removeActivity(activity, context),
          child: Text("Supprimer")),
      TextButton(
          onPressed: () => Navigator.of(context).pop(), child: Text("Annuler"))
    ]);
  }
}
