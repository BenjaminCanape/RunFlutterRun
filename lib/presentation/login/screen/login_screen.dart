import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../registration/screen/registration_screen.dart';

import '../../common/core/utils/form_utils.dart';
import '../../common/core/validators/login_validators.dart';
import '../../common/core/utils/ui_utils.dart';
import '../view_model/login_view_model.dart';

class LoginScreen extends HookConsumerWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Constructs a [LoginScreen].
  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginViewModelProvider);
    final provider = ref.watch(loginViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      body: state.isLogging
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
                          '${AppLocalizations.of(context).hello},',
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
                                    AppLocalizations.of(context).email,
                                    dark: true,
                                    icon: Icons.email),
                                validator: (value) =>
                                    LoginValidators.email(context, value),
                                onSaved: (value) {
                                  provider.setUsername(value);
                                },
                              ),
                              TextFormField(
                                style: FormUtils.darkTextFormFieldStyle,
                                decoration: FormUtils.createInputDecorative(
                                    AppLocalizations.of(context).password,
                                    dark: true,
                                    icon: Icons.password),
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
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      transitionDuration:
                                          const Duration(milliseconds: 500),
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          SlideTransition(
                                        position: Tween<Offset>(
                                          begin: const Offset(1.0, 0.0),
                                          end: Offset.zero,
                                        ).animate(animation),
                                        child: RegistrationScreen(),
                                      ),
                                    ),
                                  );
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
