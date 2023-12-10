import 'package:flutter/material.dart';

/// Utility class for color-related operations.
class ColorUtils {
  static Color main = Colors.teal.shade800;
  static Color mainDarker = Colors.teal.shade900;
  static Color mainMedium = Colors.teal.shade700;
  static Color mainLight = Colors.teal.shade100;

  static Color error = Colors.red.shade600;
  static Color errorDarker = Colors.red.shade800;
  static Color errorLight = Colors.red.shade100;

  static Color warning = Colors.orange;

  static Color white = Colors.white;
  static Color black = Colors.black;
  static Color red = Colors.red;
  static Color green = Colors.green;
  static Color greenDarker = Colors.green.shade700;
  static Color transparent = Colors.transparent;
  static Color grey = Colors.grey.shade600;
  static Color greyDarker = Colors.grey.shade700;
  static Color greyLight = Colors.grey.shade300;
  static Color blueGrey = Colors.blueGrey;
  static Color blueGreyDarker = Colors.blueGrey.shade900;

  /// List of colors used for generating color tuples.
  static List<Color> colorList = [
    Colors.teal,
    Colors.orange,
    Colors.blueGrey,
    Colors.red
  ];

  /// Generates a darker color based on the given [baseColor].
  ///
  /// The [baseColor] is used as the reference color for generating the darker color.
  /// The darker color is determined based on the luminance of the base color.
  static Color generateDarkColor(Color baseColor) {
    final luminance = baseColor.computeLuminance();
    final darkColor =
        luminance > 0.5 ? baseColor.withOpacity(0.8) : baseColor.darker();
    return darkColor;
  }

  /// Generates a lighter color based on the given [baseColor].
  ///
  /// The [baseColor] is used as the reference color for generating the lighter color.
  /// The lighter color is determined based on the luminance of the base color.
  static Color generateLightColor(Color baseColor) {
    final luminance = baseColor.computeLuminance();
    final lightColor =
        luminance > 0.5 ? baseColor.lighter() : baseColor.withOpacity(0.8);
    return lightColor;
  }

  /// Generates a color tuple from the [colorList] based on the given [index].
  ///
  /// The [index] is used to select the base color from the color list.
  /// The base color is then used to generate a dark color and a light color,
  /// forming a color tuple of length 2.
  static List<Color> generateColorTupleFromIndex(int index) {
    final baseColor = colorList[index % colorList.length];
    final darkColor = generateDarkColor(baseColor);
    final lightColor = generateLightColor(baseColor);
    return [darkColor, lightColor];
  }
}

/// Extension methods for the [Color] class.
extension ColorExtension on Color {
  /// Returns a darker shade of the color.
  ///
  /// The [factor] determines the darkness of the shade.
  /// A factor of 0.0 represents the same color, while a factor of 1.0 represents a fully dark color.
  Color darker([double factor = 0.1]) {
    return Color.fromARGB(
      alpha,
      (red * (1.0 - factor)).round(),
      (green * (1.0 - factor)).round(),
      (blue * (1.0 - factor)).round(),
    );
  }

  /// Returns a lighter shade of the color.
  ///
  /// The [factor] determines the lightness of the shade.
  /// A factor of 0.0 represents the same color, while a factor of 1.0 represents a fully light color.
  Color lighter([double factor = 0.1]) {
    return Color.fromARGB(
      alpha,
      (red + (255 - red) * factor).round(),
      (green + (255 - green) * factor).round(),
      (blue + (255 - blue) * factor).round(),
    );
  }
}
