import 'package:flutter/material.dart';

import 'color_utils.dart';

/// Utility class for form-related operations.
class FormUtils {
  /// Button style used for form buttons.
  static final ButtonStyle buttonStyle = createButtonStyle(ColorUtils.main);

  /// Default text style for form fields.
  static const TextStyle textFormFieldStyle = TextStyle(fontSize: 20);

  /// Dark text style for form fields.
  static TextStyle darkTextFormFieldStyle = TextStyle(
    fontSize: 20,
    color: ColorUtils.white,
  );

  /// Creates a button style with the given [backgroundColor].
  ///
  /// The [backgroundColor] determines the background color of the button.
  /// Returns the created button style.
  static ButtonStyle createButtonStyle(Color backgroundColor) {
    return ButtonStyle(
      textStyle: WidgetStateProperty.all(TextStyle(
        fontSize: 20,
        color: ColorUtils.white,
      )),
      minimumSize: WidgetStateProperty.all(const Size(150, 50)),
      backgroundColor: WidgetStateProperty.all<Color>(backgroundColor),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  /// Creates an input decoration for form fields.
  ///
  /// The [text] is the label text for the form field.
  /// The [dark] flag determines if the form field should use dark colors.
  /// The [icon] is an optional icon for the form field.
  /// Returns the created input decoration.
  static InputDecoration createInputDecorative(String text,
      {bool? dark, IconData? icon}) {
    dark ??= false;
    final color = dark ? ColorUtils.mainLight : ColorUtils.main;
    final errorColor = dark ? ColorUtils.errorLight : ColorUtils.error;

    return InputDecoration(
      icon: icon != null ? Icon(icon) : null,
      iconColor: color,
      errorStyle: TextStyle(color: errorColor),
      errorBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: errorColor)),
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: color)),
      border: UnderlineInputBorder(borderSide: BorderSide(color: color)),
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: color)),
      focusedErrorBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: errorColor)),
      focusColor: color,
      labelStyle: TextStyle(color: color),
      labelText: text,
    );
  }
}
