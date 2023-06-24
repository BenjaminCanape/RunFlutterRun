import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:run_flutter_run/presentation/settings/view_model/settings_view_model.dart';
import 'package:run_flutter_run/presentation/settings/widgets/delete_account_alert.dart';

import '../../common/ui/form.dart';

class SettingsScreen extends HookConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.read(settingsViewModelProvider);
    final provider = ref.read(settingsViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 40,
        leading: const Icon(
          Icons.settings,
          color: Colors.grey,
        ),
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
          color: Colors.grey.shade800,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        title: Text(
          AppLocalizations.of(context).settings.toUpperCase(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: state.isLoading
              ? const CircularProgressIndicator()
              : Column(
                  children: [
                    const SizedBox(height: 40),
                    ElevatedButton(
                      style: buttonStyle,
                      onPressed: () => provider.logout(context),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.logout),
                          const SizedBox(width: 8),
                          Text(AppLocalizations.of(context).logout),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.red.shade600)),
                      onPressed: () => showDialog(
                          context: context,
                          builder: (context) {
                            return const DeleteAccountAlert();
                          }),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.delete),
                          const SizedBox(width: 8),
                          Text(AppLocalizations.of(context).delete_account),
                        ],
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
