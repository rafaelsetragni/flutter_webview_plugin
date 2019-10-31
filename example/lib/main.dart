import 'package:flutter/material.dart';

import 'package:flutter_webview_plugin_example/util/config.dart';
import 'package:flutter_webview_plugin_example/pages/examples.dart';
import 'package:flutter_webview_plugin_example/util/webcolors.dart';

void main() async {
  runApp(await AppConfig.getConfig(new MyApp()));
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final config = AppConfig.of(context);

    final MaterialColor primaryColor = WebColor.googleMaterialColorFromHex(config.theme['primaryColor']);

    return MaterialApp(
        title: config.appName,
        color: Colors.white,
        theme: ThemeData(

          brightness:     Brightness.light,
          primaryColor:   primaryColor.shade500,
          accentColor:    primaryColor.shade500,
          primarySwatch:  primaryColor,

          // Define the default font family.
          //fontFamily: 'Montserrat',

          // ignore: prefer_const_constructors
          textTheme: TextTheme(
            headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            title:    TextStyle(fontSize: 24.0, fontStyle: FontStyle.normal),
            body1:    TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          ),

        ),
        home: MyHomePage(title: config.appName),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: ExamplesPage()
    );
  }
}