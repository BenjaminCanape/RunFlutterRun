import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:run_run_run/domain/entities/activity.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../view_model/activity_details_view_model.dart';

class RemoveAlert extends HookConsumerWidget {
  final Activity activity;

  bool isLoading = false;

  RemoveAlert({Key? key, required this.activity}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ignore: unused_local_variable
    final state = ref.watch(activityDetailsViewModelProvider);
    final provider = ref.read(activityDetailsViewModelProvider.notifier);

    return AlertDialog(
        title: isLoading
            ? const CircularProgressIndicator()
            : Text('${AppLocalizations.of(context).ask_activity_removal}'),
        actions: [
          TextButton(
              onPressed: () {
                if (isLoading == false) {
                  isLoading = true;
                  provider.removeActivity(activity, context);
                }
              },
              child: Text('${AppLocalizations.of(context).delete}')),
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('${AppLocalizations.of(context).cancel}'))
        ]);
  }
}
