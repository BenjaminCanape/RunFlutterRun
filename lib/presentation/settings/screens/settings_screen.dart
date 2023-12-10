import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:run_flutter_run/presentation/common/core/utils/color_utils.dart';

import '../../common/core/utils/form_utils.dart';
import '../../common/core/utils/ui_utils.dart';
import '../view_model/settings_view_model.dart';
import 'edit_password_screen.dart';
import 'edit_profile_screen.dart';

class SettingsScreen extends HookConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(settingsViewModelProvider);
    final provider = ref.watch(settingsViewModelProvider.notifier);

    return Scaffold(
      body: Center(
        child: state.isLoading
            ? UIUtils.loader
            : Column(
                children: [
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
                              child: EditProfileScreen(),
                            ),
                          ),
                        );
                      },
                      child: Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.person,
                              color: ColorUtils.white,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context)!.edit_profile,
                              style: FormUtils.darkTextFormFieldStyle,
                            ),
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
                            Icon(
                              Icons.edit,
                              color: ColorUtils.white,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context)!.edit_password,
                              style: FormUtils.darkTextFormFieldStyle,
                            ),
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
                            Icon(
                              Icons.logout,
                              color: ColorUtils.white,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context)!.logout,
                              style: FormUtils.darkTextFormFieldStyle,
                            ),
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
                      style: FormUtils.createButtonStyle(ColorUtils.error),
                      onPressed: () => QuickAlert.show(
                        context: context,
                        type: QuickAlertType.confirm,
                        title:
                            AppLocalizations.of(context)!.ask_account_removal,
                        confirmBtnText: AppLocalizations.of(context)!.delete,
                        cancelBtnText: AppLocalizations.of(context)!.cancel,
                        confirmBtnColor: ColorUtils.red,
                        onCancelBtnTap: () => Navigator.of(context).pop(),
                        onConfirmBtnTap: () => provider.deleteUserAccount(),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.delete,
                              color: ColorUtils.white,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context)!.delete_account,
                              style: FormUtils.darkTextFormFieldStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
