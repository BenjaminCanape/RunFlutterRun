import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:run_flutter_run/presentation/common/core/utils/color_utils.dart';

void main() {
  test('generateDarkColor should return a darker color', () {
    const baseColor = Colors.teal;
    final darkColor = ColorUtils.generateDarkColor(baseColor);
    expect(darkColor, isNot(baseColor));
    expect(darkColor, isInstanceOf<Color>());
  });

  test('generateLightColor should return a lighter color', () {
    const baseColor = Colors.teal;
    final lightColor = ColorUtils.generateLightColor(baseColor);
    expect(lightColor, isNot(baseColor));
    expect(lightColor, isInstanceOf<Color>());
  });

  test('generateColorTupleFromIndex should return a tuple of colors', () {
    const index = 0;
    final colorTuple = ColorUtils.generateColorTupleFromIndex(index);
    expect(colorTuple, isList);
    expect(colorTuple, hasLength(2));
    expect(colorTuple[0], isInstanceOf<Color>());
    expect(colorTuple[1], isInstanceOf<Color>());
  });

  test('darker should return a darker shade of the color', () {
    const color = Colors.teal;
    final darkerColor = color.darker();
    expect(darkerColor, isNot(color));
    expect(darkerColor, isInstanceOf<Color>());
  });

  test('lighter should return a lighter shade of the color', () {
    const color = Colors.teal;
    final lighterColor = color.lighter();
    expect(lighterColor, isNot(color));
    expect(lighterColor, isInstanceOf<Color>());
  });
}
