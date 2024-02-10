import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/core/utils/color_utils.dart';
import '../../common/core/utils/form_utils.dart';
import '../../common/core/utils/ui_utils.dart';
import '../../common/core/validators/login_validators.dart';
import '../view_model/edit_password_view_model.dart';

class EditPasswordScreen extends HookConsumerWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  EditPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(editPasswordViewModelProvider);
    final provider = ref.watch(editPasswordViewModelProvider.notifier);

    return Scaffold(
      body: state.isEditing
          ? Center(child: UIUtils.loader)
          : SafeArea(
              child: Column(
                children: [
                  UIUtils.createHeader(
                      AppLocalizations.of(context)!.edit_password),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          state.errorOnRequest
                              ? Column(children: [
                                  Text(
                                    AppLocalizations.of(context)!
                                        .edit_password_error,
                                    style: TextStyle(
                                        color: ColorUtils.red, fontSize: 18),
                                  ),
                                  const SizedBox(height: 20)
                                ])
                              : Container(),
                          // Current Password TextFormField
                          TextFormField(
                            style: FormUtils.textFormFieldStyle,
                            decoration: FormUtils.createInputDecorative(
                              AppLocalizations.of(context)!.current_password,
                              dark: false,
                              icon: Icons.password,
                            ),
                            obscureText: true,
                            validator: (value) =>
                                LoginValidators.password(context, value),
                            onSaved: (value) {
                              provider.setCurrentPassword(value);
                            },
                          ),
                          // Password TextFormField
                          TextFormField(
                            style: FormUtils.textFormFieldStyle,
                            decoration: FormUtils.createInputDecorative(
                              AppLocalizations.of(context)!.new_password,
                              dark: false,
                              icon: Icons.password,
                            ),
                            obscureText: true,
                            validator: (value) =>
                                LoginValidators.password(context, value),
                            onChanged: (value) {
                              provider.setPassword(value);
                            },
                          ),
                          // Confirm Password TextFormField
                          TextFormField(
                            style: FormUtils.textFormFieldStyle,
                            decoration: FormUtils.createInputDecorative(
                              '${AppLocalizations.of(context)!.verify} ${AppLocalizations.of(context)!.password}',
                              dark: false,
                              icon: Icons.password,
                            ),
                            obscureText: true,
                            validator: (value) =>
                                LoginValidators.confirmPassword(
                              context,
                              value,
                              state.password,
                            ),
                            onChanged: (value) {
                              provider.setCheckPassword(value);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: state.isEditing
          ? Container()
          : Stack(
              children: [
                Positioned(
                  bottom: 16,
                  right: 80,
                  child: FloatingActionButton(
                    heroTag: 'save_button',
                    backgroundColor: ColorUtils.main,
                    elevation: 4.0,
                    child: Icon(
                      Icons.save,
                      color: ColorUtils.white,
                    ),
                    onPressed: () {
                      provider.submitForm(context, formKey);
                    },
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 80,
                  child: UIUtils.createBackButton(context),
                ),
              ],
            ),
    );
  }
}
