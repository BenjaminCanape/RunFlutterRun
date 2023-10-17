import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../edit_password/screen/edit_password_screen.dart';

import '../../common/core/utils/form_utils.dart';
import '../../common/core/utils/ui_utils.dart';
import '../view_model/settings_view_model.dart';

class SettingsScreen extends HookConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(settingsViewModelProvider);
    final provider = ref.watch(settingsViewModelProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: state.isLoading
              ? UIUtils.loader
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 0, top: 12),
                      child: Text(
                        AppLocalizations.of(context)!.settings,
                        style: const TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: 40),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ElevatedButton(
                        style: FormUtils.buttonStyle,
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 500),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(1.0, 0.0),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: EditPasswordScreen(),
                              ),
                            ),
                          );
                        },
                        child: Align(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.edit),
                              const SizedBox(width: 8),
                              Text(AppLocalizations.of(context)!.edit_password),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ElevatedButton(
                        style: FormUtils.buttonStyle,
                        onPressed: () => provider.logoutUser(),
                        child: Align(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.logout),
                              const SizedBox(width: 8),
                              Text(AppLocalizations.of(context)!.logout),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ElevatedButton(
                        style: FormUtils.createButtonStyle(Colors.red.shade600),
                        onPressed: () => QuickAlert.show(
                          context: context,
                          type: QuickAlertType.confirm,
                          title:
                              AppLocalizations.of(context)!.ask_account_removal,
                          confirmBtnText: AppLocalizations.of(context)!.delete,
                          cancelBtnText: AppLocalizations.of(context)!.cancel,
                          confirmBtnColor: Colors.red,
                          onCancelBtnTap: () => Navigator.of(context).pop(),
                          onConfirmBtnTap: () => provider.deleteUserAccount(),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.delete),
                              const SizedBox(width: 8),
                              Text(
                                  AppLocalizations.of(context)!.delete_account),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
