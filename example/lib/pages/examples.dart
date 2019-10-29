import 'package:flutter/material.dart';

import 'package:flutter_webview_plugin_example/util/config.dart';
import 'package:flutter_webview_plugin_example/pages/webview_widget.dart';

class ExamplesPage extends StatefulWidget {

  @override
  _ExamplesPageState createState() => new _ExamplesPageState();
}

class _ExamplesPageState extends State<ExamplesPage> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget title(String text) => Container(
    margin: EdgeInsets.symmetric(vertical: 4),
    child: Text(
      text,
      style: Theme.of(context).textTheme.title,
      textAlign: TextAlign.center,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final config = AppConfig.of(context);

    final String initialUrl = config.getFullDomainUrl();

    final _urlCtrl = TextEditingController(text: initialUrl );
    final _userCtrl = TextEditingController(text: config.baseUserAgent);

    return Scaffold(
          key: _scaffoldKey,
          body: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: ListView(
              children: <Widget>[

                const SizedBox(height: 32),
                title('Initial URL'),
                Container(
                  padding: const EdgeInsets.all(24.0),
                  child: TextField(controller: _urlCtrl),
                ),

                const SizedBox(height: 32),
                title('Base User Agent'),
                Container(
                  padding: const EdgeInsets.all(24.0),
                  child: TextField(controller: _userCtrl),
                ),
                const SizedBox(height: 32),

                RaisedButton(
                  child: const Text('Webview (float rect)'),
                  onPressed: () {
                      _scaffoldKey.currentState.showSnackBar(
                        const SnackBar(content: const Text('Webview Destroyed')));
                  },
                ),
                RaisedButton(
                  child: const Text('"Hidden" Webview'),
                  onPressed: () {
                  },
                ),
                RaisedButton(
                  child: const Text('Fullscreen Webview'),
                  onPressed: () {
                  },
                ),
                RaisedButton(
                  child: const Text('Widget Webview'),
                  onPressed: () => Navigator.push(
                      context,
                      new MaterialPageRoute(builder: (context) =>
                            WebviewWidget(
                              initialUrl: _urlCtrl.text,
                              config: config
                          )
                      )
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          )
    );
  }
}
