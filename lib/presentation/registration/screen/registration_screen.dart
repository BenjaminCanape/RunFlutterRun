import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/ui/form.dart';
import '../../common/validators/validators.dart';
import '../view_model/registration_view_model.dart';

class RegistrationScreen extends HookConsumerWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  RegistrationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(registrationViewModelProvider);
    final provider = ref.watch(registrationViewModelProvider.notifier);

    return Scaffold(
        appBar: AppBar(
          leadingWidth: 40,
          leading: const Icon(
            Icons.app_registration,
            color: Colors.grey,
          ),
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.grey.shade800,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          title: Text(
            AppLocalizations.of(context).registration.toUpperCase(),
          ),
        ),
        body: state.isLogging
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          style: textFormFieldStyle,
                          decoration: createInputDecorative(
                              AppLocalizations.of(context).email),
                          validator: (value) => emailValidation(context, value),
                          onSaved: (value) {
                            provider.setUsername(value);
                          },
                        ),
                        TextFormField(
                          style: textFormFieldStyle,
                          decoration: createInputDecorative(
                              AppLocalizations.of(context).password),
                          obscureText: true,
                          validator: (value) =>
                              passwordValidation(context, value),
                          onChanged: (value) {
                            provider.setPassword(value);
                          },
                        ),
                        TextFormField(
                          style: textFormFieldStyle,
                          decoration: createInputDecorative(
                              '${AppLocalizations.of(context).verify} ${AppLocalizations.of(context).password}'),
                          obscureText: true,
                          validator: (value) => checkPasswordValidation(
                              context, value, state.password),
                          onChanged: (value) {
                            provider.setCheckPassword(value);
                          },
                        ),
                        const SizedBox(height: 50),
                        ElevatedButton(
                          style: buttonStyle,
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
                        ElevatedButton(
                          style: buttonStyle,
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
                )),
              ));
  }
}
