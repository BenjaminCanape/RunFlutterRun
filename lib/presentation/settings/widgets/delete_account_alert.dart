import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../view_model/settings_view_model.dart';

class DeleteAccountAlert extends HookConsumerWidget {
  const DeleteAccountAlert({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(settingsViewModelProvider.notifier);

    return AlertDialog(
      title: Text(AppLocalizations.of(context).ask_account_removal),
      actions: [
        TextButton(
          onPressed: provider.deleteUserAccount,
          child: Text(AppLocalizations.of(context).delete),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context).cancel),
        ),
      ],
    );
  }
}
