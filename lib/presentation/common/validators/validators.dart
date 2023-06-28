import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FormValidations {
  static String? email(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context).form_description_email_empty;
    }
    if (!EmailValidator.validate(value)) {
      return AppLocalizations.of(context).form_description_email_not_valid;
    }
    return null;
  }

  static String? password(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context).form_description_password_empty;
    }
    return null;
  }

  static String? confirmPassword(
      BuildContext context, String? value, String? password) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context).form_description_password_empty;
    }
    if (value != password) {
      return AppLocalizations.of(context).passwords_do_not_match;
    }
    return null;
  }
}
