import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/entities/user.dart';
import '../../common/core/utils/color_utils.dart';
import '../../common/core/utils/form_utils.dart';
import '../../common/core/utils/ui_utils.dart';
import '../../common/core/validators/login_validators.dart';
import '../../common/core/widgets/upload_file.dart';
import '../../common/user/view_model/profile_picture_view_model.dart';
import '../view_model/edit_profile_view_model.dart';

class EditProfileScreen extends HookConsumerWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  EditProfileScreen({super.key});

  final editProfileFutureProvider = FutureProvider<User?>((ref) async {
    final editProfileProvider =
        ref.watch(editProfileViewModelProvider.notifier);
    User? user = await editProfileProvider.getCurrentUser();
    editProfileProvider.getProfilePicture(ref);

    return user;
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(editProfileViewModelProvider);
    final provider = ref.watch(editProfileViewModelProvider.notifier);

    var editProfileStateProvider = ref.watch(editProfileFutureProvider);

    return Scaffold(
        body: state.isEditing
            ? Center(child: UIUtils.loader)
            : editProfileStateProvider.when(
                data: (user) {
                  Uint8List? profilePicture;
                  user != null
                      ? profilePicture = ref
                          .watch(profilePictureViewModelProvider(user.id))
                          .profilePicture
                      : profilePicture = null;
                  return Scaffold(
                    resizeToAvoidBottomInset: true,
                    body: state.isEditing
                        ? Center(child: UIUtils.loader)
                        : SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 100.0),
                              child: ListView(
                                  keyboardDismissBehavior:
                                      ScrollViewKeyboardDismissBehavior.onDrag,
                                  children: [
                                    Column(
                                      children: [
                                        UIUtils.createHeader(
                                            AppLocalizations.of(context)!
                                                .edit_profile),
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
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .edit_profile_error,
                                                          style: TextStyle(
                                                              color: ColorUtils
                                                                  .red,
                                                              fontSize: 18),
                                                        ),
                                                        const SizedBox(
                                                            height: 20)
                                                      ])
                                                    : Container(),
                                                const SizedBox(height: 10),
                                                UploadFileWidget(
                                                    image: profilePicture,
                                                    callbackFunc: provider
                                                        .chooseNewProfilePicture),
                                                // Firstname TextFormField
                                                TextFormField(
                                                  style: FormUtils
                                                      .textFormFieldStyle,
                                                  decoration: FormUtils
                                                      .createInputDecorative(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .firstname,
                                                    dark: false,
                                                    icon: Icons.person,
                                                  ),
                                                  validator: (value) =>
                                                      LoginValidators.name(
                                                          context, value),
                                                  onSaved: (value) {
                                                    provider
                                                        .setFirstname(value);
                                                  },
                                                  initialValue: state.firstname,
                                                ),
                                                // Lastname TextFormField
                                                TextFormField(
                                                  style: FormUtils
                                                      .textFormFieldStyle,
                                                  decoration: FormUtils
                                                      .createInputDecorative(
                                                    AppLocalizations.of(
                                                            context)!
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
                },
                loading: () {
                  return Center(child: UIUtils.loader);
                },
                error: (error, stackTrace) {
                  return Text('$error');
                },
              ));
  }
}
