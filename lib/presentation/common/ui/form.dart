import 'package:flutter/material.dart';

var buttonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Colors.teal.shade800));

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
