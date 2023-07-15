import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../common/core/utils/form_utils.dart';
import '../../common/core/validators/login_validators.dart';
import '../../common/core/utils/ui_utils.dart';
import '../view_model/edit_password_view_model.dart';

class EditPasswordScreen extends HookConsumerWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  EditPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(editPasswordViewModelProvider);
    final provider = ref.watch(editPasswordViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      body: state.isEditing
          ? const Center(child: UIUtils.loader)
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 0, top: 150),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Text(
                          AppLocalizations.of(context).edit_password,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 33,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          // Current Password TextFormField
                          TextFormField(
                            style: FormUtils.darkTextFormFieldStyle,
                            decoration: FormUtils.createInputDecorative(
                              AppLocalizations.of(context).current_password,
                              dark: true,
                              icon: Icons.password,
                            ),
                            validator: (value) =>
                                LoginValidators.password(context, value),
                            onSaved: (value) {
                              provider.setCurrentPassword(value);
                            },
                          ),
                          // Password TextFormField
                          TextFormField(
                            style: FormUtils.darkTextFormFieldStyle,
                            decoration: FormUtils.createInputDecorative(
                              AppLocalizations.of(context).new_password,
                              dark: true,
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
                            style: FormUtils.darkTextFormFieldStyle,
                            decoration: FormUtils.createInputDecorative(
                              '${AppLocalizations.of(context).verify} ${AppLocalizations.of(context).password}',
                              dark: true,
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
                          const SizedBox(height: 50),
                          // Validate Button
                          ElevatedButton(
                            style: FormUtils.buttonStyle,
                            onPressed: () {
                              provider.submitForm(context, formKey);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.check),
                                const SizedBox(width: 8),
                                Text(AppLocalizations.of(context).validate),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Back Button
                          ElevatedButton(
                            style: FormUtils.buttonStyle,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.arrow_back),
                                const SizedBox(width: 8),
                                Text(AppLocalizations.of(context).back),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
