import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'color_utils.dart';

class UIUtils {
  /// A loader widget that displays a spinning animation with three bouncing balls.
  /// It is a part of the `flutter_spinkit` package.
  static final loader = SpinKitThreeBounce(
    color: ColorUtils.blueGrey, // The color of the bouncing balls
    size: 50.0, // The size of the loader widget
  );

  /// A function that create the header for a specific title
  static Column createHeader(title) {
    return Column(children: [
      Container(
        padding: const EdgeInsets.only(left: 0, top: 12),
        child: Text(
          title,
          style: TextStyle(
              color: ColorUtils.blueGrey,
              fontSize: 28,
              fontWeight: FontWeight.bold),
        ),
      ),
      const Divider(),
    ]);
  }

  static FloatingActionButton createBackButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: ColorUtils.main,
      elevation: 4.0,
      child: Icon(
        Icons.arrow_back,
        color: ColorUtils.white,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
