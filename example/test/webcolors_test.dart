import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_webview_plugin_example/util/webcolors.dart';

void main() {

  const String hexMainColor  = '#A51523';
  const Color colorMainColor = Color.fromARGB( 255, 165, 21, 35 );

  // https://angular-md-color.com/#/
  final Map<int, Color> absolutePallet =
  {
    50:   WebColor.getColor('#F4E3E5'),
    100:  WebColor.getColor('#E4B9BD'),
    200:  WebColor.getColor('#D28A91'),
    300:  WebColor.getColor('#C05B65'),
    400:  WebColor.getColor('#B33844'),
    500:  WebColor.getColor('#A51523'),
    600:  WebColor.getColor('#90121F'),
    700:  WebColor.getColor('#7C101A'),
    800:  WebColor.getColor('#670D16'),
    900:  WebColor.getColor('#520A11')
  };

  // Reference http://mcg.mbitson.com/#!?mcgpalette0=%23a51523#%2F
  final Map<int, Color> googleMaterialPallet =
  {
    50:   WebColor.getColor('#F4E3E5'),
    100:  WebColor.getColor('#E4B9BD'),
    200:  WebColor.getColor('#D28A91'),
    300:  WebColor.getColor('#C05B65'),
    400:  WebColor.getColor('#B33844'),
    500:  WebColor.getColor('#A51523'),
    600:  WebColor.getColor('#9D121F'),
    700:  WebColor.getColor('#930F1A'),
    800:  WebColor.getColor('#8A0C15'),
    900:  WebColor.getColor('#79060C')
  };

  const Color whiteWith0Alpha   = Color.fromARGB(   0, 255, 255, 255 );
  const Color whiteWith1Alpha   = Color.fromARGB(   1, 255, 255, 255 );
  const Color whiteWith255Alpha = Color.fromARGB( 255, 255, 255, 255 );

  const Color blackWith0Alpha   = Color.fromARGB(   0, 0, 0, 0 );
  const Color blackWith1Alpha   = Color.fromARGB(   1, 0, 0, 0 );
  const Color blackWith255Alpha = Color.fromARGB( 255, 0, 0, 0 );

  testWidgets('Test Hex to Int', (WidgetTester tester) async {

    expect( whiteWith255Alpha.value, WebColor.hexToInt('#ffffff'), reason: 'Lower case string' );
    expect( whiteWith255Alpha.value, WebColor.hexToInt('#FFFFFF'), reason: 'Upper case string' );

    expect( blackWith255Alpha.value, WebColor.hexToInt('#000000'),   reason: 'Simple Black' );
    expect( blackWith255Alpha.value, WebColor.hexToInt('#FF000000'), reason: 'Black with 255 alpha' );

    expect(   blackWith0Alpha.value, WebColor.hexToInt('#00000000'), reason: 'Black with 0 alpha' );
    expect(   blackWith1Alpha.value, WebColor.hexToInt('#01000000'), reason: 'Black with 1 alpha' );

    expect( whiteWith255Alpha.value, WebColor.hexToInt('#FFFFFF'),   reason: 'Simple White' );
    expect( whiteWith255Alpha.value, WebColor.hexToInt('#FFFFFFFF'), reason: 'White with 255 alpha' );

    expect(   whiteWith0Alpha.value, WebColor.hexToInt('#00FFFFFF'), reason: 'White with 0 alpha' );
    expect(   whiteWith1Alpha.value, WebColor.hexToInt('#01FFFFFF'), reason: 'White with 1 alpha' );

  });

  testWidgets('Test Int to Hex', (WidgetTester tester) async {

    expect( WebColor.intToHex( blackWith0Alpha.value ),   '#00000000', reason: 'Int to Hex conversion with 0 alpha (black)');
    expect( WebColor.intToHex( blackWith1Alpha.value ),   '#01000000', reason: 'Int to Hex conversion with 1 alpha (black)');
    expect( WebColor.intToHex( blackWith255Alpha.value ),   '#000000', reason: 'Int to Hex conversion with 255 alpha (black)');

    expect( WebColor.intToHex( whiteWith0Alpha.value ),   '#00FFFFFF', reason: 'Int to Hex conversion with 0 alpha (white)' );
    expect( WebColor.intToHex( whiteWith1Alpha.value ),   '#01FFFFFF', reason: 'Int to Hex conversion with 1 alpha (white)' );
    expect( WebColor.intToHex( whiteWith255Alpha.value ),   '#FFFFFF', reason: 'Int to Hex conversion with 255 alpha (white)' );
  });

  testWidgets('Test single web colors transation', (WidgetTester tester) async {
    expect( colorMainColor, WebColor.getColor(hexMainColor), reason: 'Color object' );
  });

  testWidgets('Test multiply web colors operation', (WidgetTester tester) async {
    expect( const Color.fromARGB(255, 106, 1, 4), WebColor.multiply(colorMainColor, colorMainColor), reason: 'Color multiply' );
  });

  testWidgets('Test mix web colors operation', (WidgetTester tester) async {
    final Color referenceColor = WebColor.multiply(colorMainColor, colorMainColor);
    expect( const Color.fromARGB(255, 138, 12, 21), WebColor.mix(referenceColor, colorMainColor, 54), reason: 'Color mixing' );
  });

  testWidgets('Test shade 50 conversion', (WidgetTester tester) async {
    final MaterialColor originalMaterialColor = MaterialColor(WebColor.hexToInt(hexMainColor), absolutePallet);
    final Color testShade50 = WebColor.shade('50', colorMainColor.value);

    expect( testShade50.red,   originalMaterialColor.shade50.red,   reason: 'red component'   );
    expect( testShade50.green, originalMaterialColor.shade50.green, reason: 'green component' );
    expect( testShade50.blue,  originalMaterialColor.shade50.blue,  reason: 'blue component'  );
  });

  testWidgets('Test shade 100 conversion', (WidgetTester tester) async {
    final MaterialColor originalMaterialColor = MaterialColor(WebColor.hexToInt(hexMainColor), absolutePallet);
    final Color testShade100 = WebColor.shade('100', colorMainColor.value);

    expect( testShade100.red,   originalMaterialColor.shade100.red,   reason: 'red component'   );
    expect( testShade100.green, originalMaterialColor.shade100.green, reason: 'green component' );
    expect( testShade100.blue,  originalMaterialColor.shade100.blue,  reason: 'blue component'  );
  });

  testWidgets('Test shade 200 conversion', (WidgetTester tester) async {
    final MaterialColor originalMaterialColor = MaterialColor(WebColor.hexToInt(hexMainColor), absolutePallet);
    final Color testShade200 = WebColor.shade('200', colorMainColor.value);

    expect( testShade200.red,   originalMaterialColor.shade200.red,   reason: 'red component'   );
    expect( testShade200.green, originalMaterialColor.shade200.green, reason: 'green component' );
    expect( testShade200.blue,  originalMaterialColor.shade200.blue,  reason: 'blue component'  );
  });

  testWidgets('Test shade 300 conversion', (WidgetTester tester) async {
    final MaterialColor originalMaterialColor = MaterialColor(WebColor.hexToInt(hexMainColor), absolutePallet);
    final Color testShade300 = WebColor.shade('300', colorMainColor.value);

    expect( testShade300.red,   originalMaterialColor.shade300.red,   reason: 'red component'   );
    expect( testShade300.green, originalMaterialColor.shade300.green, reason: 'green component' );
    expect( testShade300.blue,  originalMaterialColor.shade300.blue,  reason: 'blue component'  );
  });

  testWidgets('Test shade 400 conversion', (WidgetTester tester) async {
    final MaterialColor originalMaterialColor = MaterialColor(WebColor.hexToInt(hexMainColor), absolutePallet);
    final Color testShade400 = WebColor.shade('400', colorMainColor.value);

    expect( testShade400.red,   originalMaterialColor.shade400.red,   reason: 'red component'   );
    expect( testShade400.green, originalMaterialColor.shade400.green, reason: 'green component' );
    expect( testShade400.blue,  originalMaterialColor.shade400.blue,  reason: 'blue component'  );
  });

  testWidgets('Test shade 500 conversion', (WidgetTester tester) async {
    final MaterialColor originalMaterialColor = MaterialColor(WebColor.hexToInt(hexMainColor), absolutePallet);
    final Color testShade500 = WebColor.shade('500', colorMainColor.value);

    expect( testShade500.red,   originalMaterialColor.shade500.red,   reason: 'red component'   );
    expect( testShade500.green, originalMaterialColor.shade500.green, reason: 'green component' );
    expect( testShade500.blue,  originalMaterialColor.shade500.blue,  reason: 'blue component'  );
  });

  testWidgets('Test shade 600 conversion', (WidgetTester tester) async {
    final MaterialColor originalMaterialColor = MaterialColor(WebColor.hexToInt(hexMainColor), absolutePallet);
    final Color testShade600 = WebColor.shade('600', colorMainColor.value);

    expect( testShade600.red,   originalMaterialColor.shade600.red,   reason: 'red component'   );
    expect( testShade600.green, originalMaterialColor.shade600.green, reason: 'green component' );
    expect( testShade600.blue,  originalMaterialColor.shade600.blue,  reason: 'blue component'  );
  });

  testWidgets('Test shade 700 conversion', (WidgetTester tester) async {
    final MaterialColor originalMaterialColor = MaterialColor(WebColor.hexToInt(hexMainColor), absolutePallet);
    final Color testShade700 = WebColor.shade('700', colorMainColor.value);

    expect( testShade700.red,   originalMaterialColor.shade700.red,   reason: 'red component'   );
    expect( testShade700.green, originalMaterialColor.shade700.green, reason: 'green component' );
    expect( testShade700.blue,  originalMaterialColor.shade700.blue,  reason: 'blue component'  );
  });

  testWidgets('Test shade 800 conversion', (WidgetTester tester) async {
    final MaterialColor originalMaterialColor = MaterialColor(WebColor.hexToInt(hexMainColor), absolutePallet);
    final Color testShade800 = WebColor.shade('800', colorMainColor.value);

    expect( testShade800.red,   originalMaterialColor.shade800.red,   reason: 'red component'   );
    expect( testShade800.green, originalMaterialColor.shade800.green, reason: 'green component' );
    expect( testShade800.blue,  originalMaterialColor.shade800.blue,  reason: 'blue component'  );
  });

  testWidgets('Test shade 900 conversion', (WidgetTester tester) async {
    final MaterialColor originalMaterialColor = MaterialColor(WebColor.hexToInt(hexMainColor), absolutePallet);
    final Color testShade900 = WebColor.shade('900', colorMainColor.value);

    expect( testShade900.red,   originalMaterialColor.shade900.red,   reason: 'red component'   );
    expect( testShade900.green, originalMaterialColor.shade900.green, reason: 'green component' );
    expect( testShade900.blue,  originalMaterialColor.shade900.blue,  reason: 'blue component'  );
  });

  testWidgets('Test absolute material colors', (WidgetTester tester) async {

    final MaterialColor originalMaterialColor = MaterialColor(WebColor.hexToInt(hexMainColor), absolutePallet);
    final MaterialColor generatedMaterialColor  = WebColor.materialColorFromHex(hexMainColor);

    expect(generatedMaterialColor.shade50,  originalMaterialColor.shade50,  reason: 'shade 50'  );
    expect(generatedMaterialColor.shade100, originalMaterialColor.shade100, reason: 'shade 100' );
    expect(generatedMaterialColor.shade200, originalMaterialColor.shade200, reason: 'shade 200' );
    expect(generatedMaterialColor.shade300, originalMaterialColor.shade300, reason: 'shade 300' );
    expect(generatedMaterialColor.shade400, originalMaterialColor.shade400, reason: 'shade 400' );
    expect(generatedMaterialColor.shade500, originalMaterialColor.shade500, reason: 'shade 500' );
    expect(generatedMaterialColor.shade600, originalMaterialColor.shade600, reason: 'shade 600' );
    expect(generatedMaterialColor.shade700, originalMaterialColor.shade700, reason: 'shade 700' );
    expect(generatedMaterialColor.shade800, originalMaterialColor.shade800, reason: 'shade 800' );
    expect(generatedMaterialColor.shade900, originalMaterialColor.shade900, reason: 'shade 900' );
  });

  testWidgets('Test Google material colors', (WidgetTester tester) async {

    final MaterialColor originalMaterialColor = MaterialColor(WebColor.hexToInt(hexMainColor), googleMaterialPallet);
    final MaterialColor generatedMaterialColor  = WebColor.googleMaterialColorFromHex(hexMainColor);

    expect(generatedMaterialColor.shade50,  originalMaterialColor.shade50,  reason: 'shade 50'  );
    expect(generatedMaterialColor.shade100, originalMaterialColor.shade100, reason: 'shade 100' );
    expect(generatedMaterialColor.shade200, originalMaterialColor.shade200, reason: 'shade 200' );
    expect(generatedMaterialColor.shade300, originalMaterialColor.shade300, reason: 'shade 300' );
    expect(generatedMaterialColor.shade400, originalMaterialColor.shade400, reason: 'shade 400' );
    expect(generatedMaterialColor.shade500, originalMaterialColor.shade500, reason: 'shade 500' );
    expect(generatedMaterialColor.shade600, originalMaterialColor.shade600, reason: 'shade 600' );
    expect(generatedMaterialColor.shade700, originalMaterialColor.shade700, reason: 'shade 700' );
    expect(generatedMaterialColor.shade800, originalMaterialColor.shade800, reason: 'shade 800' );
    expect(generatedMaterialColor.shade900, originalMaterialColor.shade900, reason: 'shade 900' );
  });

}