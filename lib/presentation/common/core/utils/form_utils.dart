import 'package:flutter/material.dart';

class FormUtils {
  static final ButtonStyle buttonStyle =
      createButtonStyle(Colors.teal.shade800);
  static const TextStyle textFormFieldStyle = TextStyle(fontSize: 20);
  static const TextStyle darkTextFormFieldStyle =
      TextStyle(fontSize: 20, color: Colors.white);

  static ButtonStyle createButtonStyle(Color backgroundColor) {
    return ButtonStyle(
        textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 20)),
        minimumSize: MaterialStateProperty.all(const Size(150, 50)),
        backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
  }

  static InputDecoration createInputDecorative(String text,
      {bool? dark, IconData? icon}) {
    dark ??= false;
    final color = dark ? Colors.teal.shade200 : Colors.red.shade800;
    final errorColor = dark ? Colors.red.shade200 : Colors.red.shade600;

    return InputDecoration(
      icon: icon != null ? Icon(icon) : null,
      iconColor: color,
      errorStyle: TextStyle(
        color: errorColor,
      ),
      errorBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: errorColor)),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: color),
      ),
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: color),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: color),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: errorColor),
      ),
      focusColor: color,
      labelStyle: TextStyle(
        color: color,
      ),
      labelText: text,
    );
  }
}
