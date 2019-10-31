import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

// ignore: avoid_classes_with_only_static_members
class WebColor{

  static final Map<String, double> _intensities = {
      '50': 0.88,
     '100': 0.7,
     '200': 0.5,
     '300': 0.3,
     '400': 0.15,
     '500': 0,
     '600': -0.125,
     '700': -0.25,
     '800': -0.375,
     '900': -0.5,
    'A100': 0.7,
    'A200': 0.5,
    'A400': 0.166,
    'A700': -0.25
  };

  static Color multiply(Color colorA, Color colorB){
    return Color.fromARGB(
        (colorA.alpha * colorB.alpha / 255).floor(),
        (colorA.red   * colorB.red   / 255).floor(),
        (colorA.green * colorB.green / 255).floor(),
        (colorA.blue  * colorB.blue  / 255).floor(),
    );
  }

  // https://stackoverflow.com/questions/28503998/how-to-create-custom-palette-with-custom-color-for-material-design-app/36229022#36229022
  static Color shade(String intensity, int mainColor, {Color baseWhite, Color baseBlack}){

    baseWhite = baseWhite == null ? Colors.white : baseWhite;
    baseBlack = baseBlack == null ? Colors.black : baseBlack;

    final double percent = _intensities[intensity];
    final bool goLighten = percent >= 0;

    final Color mainReference = goLighten ? baseWhite : baseBlack;

    final int R = mainColor >> 16 & 0x0000FF,
              G = mainColor >> 8  & 0x0000FF,
              B = mainColor >> 0  & 0x0000FF;

    int Rp = ((mainReference.red   - R) * percent).round(),
        Gp = ((mainReference.green - G) * percent).round(),
        Bp = ((mainReference.blue  - B) * percent).round();

    Rp = goLighten ? Rp : -Rp;
    Gp = goLighten ? Gp : -Gp;
    Bp = goLighten ? Bp : -Bp;

    return Color.fromARGB( 255, R + Rp, G + Gp, B + Bp );
  }

  // http://mcg.mbitson.com
  static Color mix(Color color1, Color color2, amount) {

    double p = amount / 100;
    double w = p * 2 - 1;
    int a = color2.alpha - color1.alpha;

    double w1;

    if (w * a == -1) {
      w1 = w;
    } else {
      w1 = (w + a) / (1 + w * a);
    }

    w1 = (w1 + 1) / 2;

    double w2 = 1 - w1;

    return Color.fromARGB(
        (color2.alpha  * p  + color1.alpha * (1 - p)).round(),
        (color2.red    * w1 + color1.red   * w2).round(),
        (color2.green  * w1 + color1.green * w2).round(),
        (color2.blue   * w1 + color1.blue  * w2).round()
    );
  }

  static Color getColor(String hexColor) {
    return new Color(hexToInt(hexColor));
  }

  static MaterialColor materialColorFromHex(String hexColor, {Color baseWhite, Color baseBlack}){
    final int mainColorValue = hexToInt(hexColor);

    baseWhite = baseWhite == null ? Colors.white : baseWhite;
    baseBlack = baseBlack == null ? Colors.black : baseBlack;

    return MaterialColor(
      mainColorValue,
      <int, Color>{
        50:  WebColor.shade( 50.toString(), mainColorValue, baseWhite: baseWhite, baseBlack: baseBlack),
        100: WebColor.shade(100.toString(), mainColorValue, baseWhite: baseWhite, baseBlack: baseBlack),
        200: WebColor.shade(200.toString(), mainColorValue, baseWhite: baseWhite, baseBlack: baseBlack),
        300: WebColor.shade(300.toString(), mainColorValue, baseWhite: baseWhite, baseBlack: baseBlack),
        400: WebColor.shade(400.toString(), mainColorValue, baseWhite: baseWhite, baseBlack: baseBlack),

        500: WebColor.shade(500.toString(), mainColorValue, baseWhite: baseWhite, baseBlack: baseBlack),

        600: WebColor.shade(600.toString(), mainColorValue, baseWhite: baseWhite, baseBlack: baseBlack),
        700: WebColor.shade(700.toString(), mainColorValue, baseWhite: baseWhite, baseBlack: baseBlack),
        800: WebColor.shade(800.toString(), mainColorValue, baseWhite: baseWhite, baseBlack: baseBlack),
        900: WebColor.shade(900.toString(), mainColorValue, baseWhite: baseWhite, baseBlack: baseBlack),
      },
    );
  }

  static MaterialColor googleMaterialColorFromHex(String hexColor){
    final Color mainColorReference = getColor(hexColor);

    final Color darkenReference = WebColor.getColor(hexColor);
    final Color baseWhite = Colors.white;
    final Color baseBlack = WebColor.multiply(darkenReference, darkenReference);

    return MaterialColor(
      mainColorReference.value,
      <int, Color>{
        50:  WebColor.mix( baseWhite, mainColorReference, 12 ),
        100: WebColor.mix( baseWhite, mainColorReference, 30 ),
        200: WebColor.mix( baseWhite, mainColorReference, 50 ),
        300: WebColor.mix( baseWhite, mainColorReference, 70 ),
        400: WebColor.mix( baseWhite, mainColorReference, 85 ),

        500: WebColor.mix( baseWhite, mainColorReference, 100 ),

        600: WebColor.mix( baseBlack, mainColorReference, 87 ),
        700: WebColor.mix( baseBlack, mainColorReference, 70 ),
        800: WebColor.mix( baseBlack, mainColorReference, 54 ),
        900: WebColor.mix( baseBlack, mainColorReference, 25 ),
      },
    );
  }

  static int hexToInt(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  static String intToHex(int intColor) {
    final String result = intColor.toRadixString(16).padLeft(8, '0').toUpperCase();
    return '#'+ (result.startsWith('FF') ? result.substring(2) : result);
  }
}