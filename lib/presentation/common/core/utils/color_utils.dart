import 'package:flutter/material.dart';

class ColorUtils {
  static List<Color> colorList = [
    Colors.teal,
    Colors.orange,
    Colors.blueGrey,
    Colors.red
  ];

  static Color generateDarkColor(Color baseColor) {
    final luminance = baseColor.computeLuminance();
    final darkColor =
        luminance > 0.5 ? baseColor.withOpacity(0.8) : baseColor.darker();
    return darkColor;
  }

  static Color generateLightColor(Color baseColor) {
    final luminance = baseColor.computeLuminance();
    final lightColor =
        luminance > 0.5 ? baseColor.lighter() : baseColor.withOpacity(0.8);
    return lightColor;
  }

  static List<Color> generateColorTupleFromIndex(int index) {
    final baseColor = colorList[index % colorList.length];
    final darkColor = generateDarkColor(baseColor);
    final lightColor = generateLightColor(baseColor);
    return [darkColor, lightColor];
  }
}

extension ColorExtension on Color {
  Color darker([double factor = 0.1]) {
    return Color.fromARGB(
      alpha,
      (red * (1.0 - factor)).round(),
      (green * (1.0 - factor)).round(),
      (blue * (1.0 - factor)).round(),
    );
  }

  Color lighter([double factor = 0.1]) {
    return Color.fromARGB(
      alpha,
      (red + (255 - red) * factor).round(),
      (green + (255 - green) * factor).round(),
      (blue + (255 - blue) * factor).round(),
    );
  }
}
