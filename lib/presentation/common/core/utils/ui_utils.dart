import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'color_utils.dart';

class UIUtils {
  /// A loader widget that displays a spinning animation with three bouncing balls.
  /// It is a part of the `flutter_spinkit` package.
  static final loader = SpinKitThreeBounce(
    color: ColorUtils.blueGrey, // The color of the bouncing balls
    size: 50.0, // The size of the loader widget
  );
}
