import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:run_flutter_run/presentation/common/core/utils/ui_utils.dart';

void main() {
  testWidgets('Loader widget should render correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: UIUtils.loader,
        ),
      ),
    );

    final finder = find.byType(SpinKitThreeBounce);
    expect(finder, findsOneWidget);

    final spinner = tester.widget<SpinKitThreeBounce>(finder);
    expect(spinner.color, equals(Colors.blueGrey));
    expect(spinner.size, equals(50.0));
  });
}
