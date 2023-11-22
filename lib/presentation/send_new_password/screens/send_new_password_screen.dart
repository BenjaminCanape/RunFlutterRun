import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/core/utils/form_utils.dart';
import '../../common/core/utils/ui_utils.dart';
import '../../common/core/validators/login_validators.dart';
import '../view_model/send_new_password_view_model.dart';

class SendNewPasswordScreen extends HookConsumerWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Constructs a [SendNewPasswordScreen].
  SendNewPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sendNewPasswordViewModelProvider);
    final provider = ref.watch(sendNewPasswordViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      body: state.isSending
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
                          AppLocalizations.of(context)!.send_new_password,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 33),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                style: FormUtils.darkTextFormFieldStyle,
                                cursorColor: Colors.teal.shade100,
                                decoration: FormUtils.createInputDecorative(
                                    AppLocalizations.of(context)!.email,
                                    dark: true,
                                    icon: Icons.email),
                                validator: (value) =>
                                    LoginValidators.email(context, value),
                                onSaved: (value) {
                                  provider.setEmail(value);
                                },
                              ),
                              const SizedBox(height: 50),
                              ElevatedButton(
                                style: FormUtils.buttonStyle,
                                onPressed: () {
                                  provider.submitForm(context, formKey);
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.send,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      AppLocalizations.of(context)!.send_mail,
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
                                    const Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
