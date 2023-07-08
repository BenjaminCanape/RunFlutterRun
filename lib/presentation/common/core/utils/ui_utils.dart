import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class UIUtils {
  /// A loader widget that displays a spinning animation with three bouncing balls.
  /// It is a part of the `flutter_spinkit` package.
  static const loader = SpinKitThreeBounce(
    color: Colors.blueGrey, // The color of the bouncing balls
    size: 50.0, // The size of the loader widget
  );
}
