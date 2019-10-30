import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:flutter_webview_plugin_example/util/webcolors.dart";

void main() {

  testWidgets("Test single web colors transation", (WidgetTester tester) async {
    expect(Color.fromARGB(255, 165, 21, 35), WebColor.getColor("#a51523"));
  });

  testWidgets("Test single web colors transation", (WidgetTester tester) async {

      //https://angular-md-color.com/#/
      Map<int, Color> testPallet =
      {
        50:   WebColor.getColor("#e9515f"),
        100:  WebColor.getColor("#e63a4b"),
        200:  WebColor.getColor("#e32336"),
        300:  WebColor.getColor("#d21b2d"),
        400:  WebColor.getColor("#bc1828"),
        500:  WebColor.getColor("a51523"),
        600:  WebColor.getColor("#8e121e"),
        700:  WebColor.getColor("#780f19"),
        800:  WebColor.getColor("#610c15"),
        900:  WebColor.getColor("#4b0910")
      };

      MaterialColor testMaterialColor = MaterialColor(WebColor.getColor("#a51523").value, testPallet);
      MaterialColor generatedMaterialColor = WebColor.getMaterialColor("#a51523");

      expect(testMaterialColor, generatedMaterialColor);
  });

}