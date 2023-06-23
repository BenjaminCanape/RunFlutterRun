import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String? emailValidation(BuildContext context, dynamic value) {
  if (value!.isEmpty) {
    return AppLocalizations.of(context).form_description_email_empty;
  }
  if (!EmailValidator.validate(value)) {
    return AppLocalizations.of(context).form_description_email_not_valid;
  }
  return null;
}

String? passwordValidation(BuildContext context, dynamic value) {
  if (value!.isEmpty) {
    return AppLocalizations.of(context).form_description_password_empty;
  }
  return null;
}

String? checkPasswordValidation(
    BuildContext context, String? value, String? password) {
  if (value!.isEmpty) {
    return AppLocalizations.of(context).form_description_password_empty;
  }
  if (value != password) {
    return AppLocalizations.of(context).passwords_do_not_match;
  }
  return null;
}
