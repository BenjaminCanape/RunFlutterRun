import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:run_flutter_run/presentation/common/core/utils/color_utils.dart';

import 'package:run_flutter_run/presentation/common/core/utils/form_utils.dart';

void main() {
  test(
      'createButtonStyle should return a ButtonStyle with the given background color',
      () {
    final backgroundColor = ColorUtils.main;
    final buttonStyle = FormUtils.createButtonStyle(backgroundColor);
    expect(buttonStyle, isInstanceOf<ButtonStyle>());
    expect(buttonStyle.backgroundColor?.resolve(<MaterialState>{}),
        equals(backgroundColor));
  });

  testWidgets(
      'createInputDecorative should return an InputDecoration with the given parameters',
      (WidgetTester tester) async {
    const labelText = 'Label';
    const dark = true;
    const icon = Icons.ac_unit;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              final inputDecoration = FormUtils.createInputDecorative(labelText,
                  dark: dark, icon: icon);
              return TextField(
                decoration: inputDecoration,
              );
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final textFieldFinder = find.byType(TextField);
    final textField = tester.widget<TextField>(textFieldFinder);
    final inputDecoration = textField.decoration as InputDecoration;

    expect(inputDecoration.labelText, equals(labelText));
    expect(inputDecoration.icon, isNotNull);
  });
}
