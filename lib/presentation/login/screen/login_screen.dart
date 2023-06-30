import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/core/utils/form_utils.dart';
import '../../common/core/validators/login_validators.dart';
import '../view_model/login_view_model.dart';

class LoginScreen extends HookConsumerWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginViewModelProvider);
    final provider = ref.watch(loginViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 40,
        leading: const Icon(
          Icons.login,
          color: Colors.grey,
        ),
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
          color: Colors.grey.shade800,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        title: Text(
          AppLocalizations.of(context).login_page.toUpperCase(),
        ),
      ),
      body: state.isLogging
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Icon(
                    Icons.run_circle,
                    size: 100,
                    color: Colors.teal.shade800,
                  ),
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
                                style: FormUtils.textFormFieldStyle,
                                cursorColor: Colors.teal.shade800,
                                decoration: FormUtils.createInputDecorative(
                                  AppLocalizations.of(context).email,
                                ),
                                validator: (value) =>
                                    LoginValidators.email(context, value),
                                onSaved: (value) {
                                  provider.setUsername(value);
                                },
                              ),
                              TextFormField(
                                style: FormUtils.textFormFieldStyle,
                                decoration: FormUtils.createInputDecorative(
                                  AppLocalizations.of(context).password,
                                ),
                                obscureText: true,
                                validator: (value) =>
                                    LoginValidators.password(context, value),
                                onSaved: (value) {
                                  provider.setPassword(value);
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
                                    const Icon(Icons.login),
                                    const SizedBox(width: 8),
                                    Text(
                                      AppLocalizations.of(context).login_page,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                style: FormUtils.buttonStyle,
                                onPressed: () {
                                  Navigator.pushNamed(context, '/register');
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.app_registration),
                                    const SizedBox(width: 8),
                                    Text(
                                      AppLocalizations.of(context).registration,
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
