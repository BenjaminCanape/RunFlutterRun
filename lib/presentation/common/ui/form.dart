import 'package:flutter/material.dart';

var buttonStyle = createButtonStyle(Colors.teal.shade800);
var textFormFieldStyle = const TextStyle(fontSize: 20);

ButtonStyle createButtonStyle(Color backgroundColor) {
  return ButtonStyle(
    textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 20)),
    minimumSize: MaterialStateProperty.all(const Size(150, 50)),
    backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
  );
}

InputDecoration createInputDecorative(String text) {
  return InputDecoration(
      errorStyle: TextStyle(
        color: Colors.red.shade800,
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.teal.shade800),
      ),
      focusColor: Colors.teal.shade800,
      labelStyle: TextStyle(
        color: Colors.teal.shade800,
      ),
      labelText: text);
}
