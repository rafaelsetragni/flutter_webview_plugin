import 'package:flutter/material.dart';

class WebColor{

  static final Map<String, double> intensities = {
    "50":  0.9,
    "100": 0.7,
    "200": 0.5,
    "300": 0.333,
    "400": 0.166,
    "500": 0,
    "600": -0.125,
    "700": -0.25,
    "800": -0.375,
    "900": -0.5,
    "A100": 0.7,
    "A200": 0.5,
    "A400": 0.166,
    "A700": -0.25
  };

  static Color shade(String intensity, int mainColor){

    int f = mainColor;
    double percent = intensities[intensity];
    double t = percent < 0 ? 0 : 255;
    double p = percent < 0 ? percent * -1 : percent;

    int R = f >> 16;
    int G = f >> 8 & 0x00FF;
    int B = f & 0x0000FF;

    double red   = ((t - R).round() * p) + R;
    double green = ((t - G).round() * p) + G;
    double blue  = ((t - B).round() * p) + B;

    return Color.fromARGB(255, red.round(), green.round(), blue.round());
  }

  static Color getColor(String hexColor) {
    return new Color(_fromHex(hexColor));
  }

  static MaterialColor getMaterialColor(String hexColor){
    final int mainColor = _fromHex(hexColor);
    return MaterialColor(
      mainColor,
      <int, Color>{
        50:  shade("50",  mainColor),
        100: shade("100", mainColor),
        200: shade("200", mainColor),
        300: shade("300", mainColor),
        400: shade("400", mainColor),
        500: shade("500", mainColor),
        600: shade("600", mainColor),
        700: shade("700", mainColor),
        800: shade("800", mainColor),
        900: shade("900", mainColor),
      },
    );
  }

  static int _fromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}