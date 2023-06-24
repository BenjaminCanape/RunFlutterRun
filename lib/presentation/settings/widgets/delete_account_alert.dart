import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:run_flutter_run/presentation/settings/view_model/settings_view_model.dart';

class DeleteAccountAlert extends HookConsumerWidget {
  const DeleteAccountAlert({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ignore: unused_local_variable
    final state = ref.read(settingsViewModelProvider);
    final provider = ref.read(settingsViewModelProvider.notifier);

    return AlertDialog(
        title: Text(AppLocalizations.of(context).ask_account_removal),
        actions: [
          TextButton(
              onPressed: () {
                provider.deleteAccount(context);
              },
              child: Text(AppLocalizations.of(context).delete)),
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context).cancel))
        ]);
  }
}
