import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Validators for login form fields.
class LoginValidators {
  /// Validates the names [value].
  ///
  /// The [context] is the build context for localization.
  /// The [value] is the name input value to validate.
  /// Returns an error message if the name is empty, or null if the name is valid.
  static String? name(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.form_description_name_empty;
    }
    return null;
  }

  /// Validates the email [value].
  ///
  /// The [context] is the build context for localization.
  /// The [value] is the email input value to validate.
  /// Returns an error message if the email is empty or not valid, or null if the email is valid.
  static String? email(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.form_description_email_empty;
    }
    if (!EmailValidator.validate(value)) {
      return AppLocalizations.of(context)!.form_description_email_not_valid;
    }
    return null;
  }

  /// Validates the password [value].
  ///
  /// The [context] is the build context for localization.
  /// The [value] is the password input value to validate.
  /// Returns an error message if the password is empty, or null if the password is valid.
  static String? password(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.form_description_password_empty;
    }
    return null;
  }

  /// Validates the confirm password [value] against the [password].
  ///
  /// The [context] is the build context for localization.
  /// The [value] is the confirm password input value to validate.
  /// The [password] is the password input value to match against.
  /// Returns an error message if the confirm password is empty or does not match the password,
  /// or null if the confirm password is valid.
  static String? confirmPassword(
      BuildContext context, String? value, String? password) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.form_description_password_empty;
    }
    if (value != password) {
      return AppLocalizations.of(context)!.passwords_do_not_match;
    }
    return null;
  }
}
