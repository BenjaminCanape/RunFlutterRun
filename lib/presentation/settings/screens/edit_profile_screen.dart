import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/core/utils/form_utils.dart';
import '../../common/core/utils/ui_utils.dart';
import '../../common/core/validators/login_validators.dart';
import '../../common/core/widgets/upload_file.dart';
import '../view_model/edit_profile_view_model.dart';

class EditProfileScreen extends HookConsumerWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  EditProfileScreen({Key? key}) : super(key: key);

  final editProfileFutureProvider = FutureProvider<void>((ref) async {
    final editProfileProvider =
        ref.watch(editProfileViewModelProvider.notifier);
    editProfileProvider.getCurrentUser();
    editProfileProvider.getProfilePicture();
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(editProfileViewModelProvider);
    final provider = ref.watch(editProfileViewModelProvider.notifier);

    var editProfileStateProvider = ref.watch(editProfileFutureProvider);

    return editProfileStateProvider.when(
      data: (_) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: state.isEditing
              ? const Center(child: UIUtils.loader)
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 100.0),
                    child: ListView(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        children: [
                          Column(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.only(left: 0, top: 12),
                                child: Text(
                                  AppLocalizations.of(context)!.edit_profile,
                                  style: const TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const Divider(),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    children: [
                                      state.errorOnRequest
                                          ? Column(children: [
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .edit_profile_error,
                                                style: const TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 18),
                                              ),
                                              const SizedBox(height: 20)
                                            ])
                                          : Container(),
                                      const SizedBox(height: 10),
                                      UploadFileWidget(
                                          image: state.profilePicture,
                                          callbackFunc:
                                              provider.chooseNewProfilePicture),
                                      // Firstname TextFormField
                                      TextFormField(
                                        style: FormUtils.textFormFieldStyle,
                                        decoration:
                                            FormUtils.createInputDecorative(
                                          AppLocalizations.of(context)!
                                              .firstname,
                                          dark: false,
                                          icon: Icons.person,
                                        ),
                                        validator: (value) =>
                                            LoginValidators.name(
                                                context, value),
                                        onSaved: (value) {
                                          provider.setFirstname(value);
                                        },
                                        initialValue: state.firstname,
                                      ),
                                      // Lastname TextFormField
                                      TextFormField(
                                        style: FormUtils.textFormFieldStyle,
                                        decoration:
                                            FormUtils.createInputDecorative(
                                          AppLocalizations.of(context)!
                                              .lastname,
                                          dark: false,
                                          icon: Icons.person,
                                        ),
                                        validator: (value) =>
                                            LoginValidators.name(
                                                context, value),
                                        onChanged: (value) {
                                          provider.setLastname(value);
                                        },
                                        initialValue: state.lastname,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ]),
                  ),
                ),
          floatingActionButton: Stack(
            children: [
              Positioned(
                bottom: 16,
                right: 80,
                child: FloatingActionButton(
                  backgroundColor: Colors.teal.shade800,
                  elevation: 4.0,
                  child: const Icon(Icons.save),
                  onPressed: () {
                    provider.submitForm(context, formKey);
                  },
                ),
              ),
              Positioned(
                bottom: 16,
                left: 80,
                child: FloatingActionButton(
                  backgroundColor: Colors.teal.shade800,
                  elevation: 4.0,
                  child: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
      loading: () {
        return const Center(child: UIUtils.loader);
      },
      error: (error, stackTrace) {
        return Text('$error');
      },
    );
  }
}
