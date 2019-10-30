import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

// ignore: avoid_classes_with_only_static_members
class WebColor{

  static Color lighten(Color color, double fraction) {

    final int red   = lightenColor(color.red, fraction);
    final int green = lightenColor(color.green, fraction);
    final int blue  = lightenColor(color.blue, fraction);

    return Color.fromARGB(color.alpha, red, green, blue);
  }

  static Color darken(Color color, double fraction) {

    final int red   = darkenColor(color.red, fraction);
    final int green = darkenColor(color.green, fraction);
    final int blue  = darkenColor(color.blue, fraction);

    return Color.fromARGB(color.alpha, red, green, blue);
  }

  static int darkenColor(int color, double fraction) {
    return math.max((color - (color * fraction)).round(), 0);
  }

  static int lightenColor(int color, double fraction) {
    return math.min((color + (color * fraction)).round(), 255);
  }

  static Color getColor(String hexColor) {
    return new Color(_fromHex(hexColor));
  }

  static MaterialColor getMaterialColor(String hexColor){
    final Color mainColor = getColor(hexColor);
    return MaterialColor(
      _fromHex(hexColor),
      <int, Color>{
        50:  WebColor.lighten(mainColor, 52),
        100: WebColor.lighten(mainColor, 37),
        200: WebColor.lighten(mainColor, 26),
        300: WebColor.lighten(mainColor, 12),
        400: WebColor.lighten(mainColor, 6),

        500: WebColor.lighten(mainColor, 0),

        600: WebColor.darken(mainColor, 6),
        700: WebColor.darken(mainColor, 12),
        800: WebColor.darken(mainColor, 18),
        900: WebColor.darken(mainColor, 24),
      },
    );
  }

  static int _fromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}