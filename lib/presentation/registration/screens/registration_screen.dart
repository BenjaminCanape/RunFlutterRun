import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/core/utils/color_utils.dart';
import '../../common/core/utils/form_utils.dart';
import '../../common/core/utils/ui_utils.dart';
import '../../common/core/validators/login_validators.dart';
import '../view_model/registration_view_model.dart';

class RegistrationScreen extends HookConsumerWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(registrationViewModelProvider);
    final provider = ref.watch(registrationViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: ColorUtils.blueGreyDarker,
      body: state.isLogging
          ? Center(child: UIUtils.loader)
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
                          '${AppLocalizations.of(context)!.welcome},',
                          style: TextStyle(
                            color: ColorUtils.white,
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
                          // Firstname TextFormField
                          TextFormField(
                            style: FormUtils.darkTextFormFieldStyle,
                            decoration: FormUtils.createInputDecorative(
                              AppLocalizations.of(context)!.firstname,
                              dark: true,
                              icon: Icons.person,
                            ),
                            validator: (value) =>
                                LoginValidators.name(context, value),
                            onSaved: (value) {
                              provider.setFirstname(value);
                            },
                          ),
                          // Lastname TextFormField
                          TextFormField(
                            style: FormUtils.darkTextFormFieldStyle,
                            decoration: FormUtils.createInputDecorative(
                              AppLocalizations.of(context)!.lastname,
                              dark: true,
                              icon: Icons.person,
                            ),
                            validator: (value) =>
                                LoginValidators.name(context, value),
                            onSaved: (value) {
                              provider.setLastname(value);
                            },
                          ),
                          // Email TextFormField
                          TextFormField(
                            style: FormUtils.darkTextFormFieldStyle,
                            decoration: FormUtils.createInputDecorative(
                              AppLocalizations.of(context)!.email,
                              dark: true,
                              icon: Icons.email,
                            ),
                            validator: (value) =>
                                LoginValidators.email(context, value),
                            onSaved: (value) {
                              provider.setUsername(value);
                            },
                          ),
                          // Password TextFormField
                          TextFormField(
                            style: FormUtils.darkTextFormFieldStyle,
                            decoration: FormUtils.createInputDecorative(
                              AppLocalizations.of(context)!.password,
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
                              '${AppLocalizations.of(context)!.verify} ${AppLocalizations.of(context)!.password}',
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
                                Icon(
                                  Icons.check,
                                  color: ColorUtils.white,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  AppLocalizations.of(context)!.validate,
                                  style: FormUtils.darkTextFormFieldStyle,
                                ),
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
                                Icon(
                                  Icons.arrow_back,
                                  color: ColorUtils.white,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  AppLocalizations.of(context)!.back,
                                  style: FormUtils.darkTextFormFieldStyle,
                                ),
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
