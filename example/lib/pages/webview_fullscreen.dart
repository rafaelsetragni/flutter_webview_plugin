import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin_example/util/config.dart';
import 'package:flutter_webview_plugin_example/util/webcolors.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_webview_plugin/imports.dart';

final Set<JavascriptChannel> jsChannels = [
  JavascriptChannel(
      name: 'Print',
      onMessageReceived: (JavascriptMessage message) {
        print(message.message);
      }),
].toSet();

class WebviewFullScreen extends StatefulWidget {

  const WebviewFullScreen({Key key, this.initialUrl, this.config}): super(key: key);

  final String initialUrl;
  final AppConfig config;

  @override
  _WebviewFullScreen createState() => new _WebviewFullScreen();
}

class _WebviewFullScreen extends State<WebviewFullScreen> {

  final flutterWebViewPlugin = FlutterWebviewPlugin();
  AppConfig config;

  String originalUserAgent;

  // On destroy stream
  StreamSubscription onDestroy;

  // On urlChanged stream
  StreamSubscription<String> onUrlChanged;

  // On urlChanged stream
  StreamSubscription<WebViewStateChanged> onStateChanged;
  StreamSubscription<WebViewHttpError> onHttpError;
  StreamSubscription<WebViewHeaders> afterHttpRequest;
  StreamSubscription<double> onProgressChanged;
  StreamSubscription<double> onScrollYChanged;
  StreamSubscription<double> onScrollXChanged;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _history = [];

  bool _loaded = false;

  @override
  void initState() {
    super.initState();

    flutterWebViewPlugin.close();

    // Add a listener to on destroy WebView, so you can make came actions.
    onDestroy = flutterWebViewPlugin.onDestroy.listen((_) {
      if (mounted) {
      }
    });

    // Add a listener to on url changed
    onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          _history.add('onUrlChanged: $url');
        });
      }
    });

    onProgressChanged =
        flutterWebViewPlugin.onProgressChanged.listen((double progress) {
          if (mounted) {
            setState(() {
              _history.add('onProgressChanged: $progress');
            });
          }
        });

    onScrollYChanged =
        flutterWebViewPlugin.onScrollYChanged.listen((double y) {
          if (mounted) {
            setState(() {
              _history.add('Scroll in Y Direction: $y');
            });
          }
        });

    onScrollXChanged =
        flutterWebViewPlugin.onScrollXChanged.listen((double x) {
          if (mounted) {
            setState(() {
              _history.add('Scroll in X Direction: $x');
            });
          }
        });

    onStateChanged =
        flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state) {
          if (mounted) {
            setState(() {
              _history.add('onStateChanged: ${state.type} ${state.url}');

              switch(state.type){
                  case WebViewState.finishLoad:
                      _loaded = true;
                      break;

                  case WebViewState.abortLoad:
                      // WKNavigationType linkActivated
                      if(state.navigationType == 7){
                        debugPrint('Opening external browser: ${state.url}');
                        launch(state.url);
                      }
                      break;

                  default:
                    break;
              }

            });
          }
        });

    onHttpError =
        flutterWebViewPlugin.onHttpError.listen((WebViewHttpError error) {
          if (mounted) {
            setState(() {
              _history.add('onHttpError: ${error.code} ${error.url}');
            });
          }
        });

    afterHttpRequest =
        flutterWebViewPlugin.afterHttpRequest.listen((WebViewHeaders headers) {
          if (mounted) {
            setState(() {
              switch(headers.baseUrl){

                case 'https://buildblocks.prodemge.gov.br/pages/home':
                  if(headers.responseHeaders.containsKey('Bearer-Token')){
                      config.preferences.setString('token', headers.responseHeaders['Bearer-Token']);
                  }
                  break;

              }
              _history.add('afterHttpRequest: ${headers.baseUrl}');
            });
          }
        });
  }

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    onDestroy.cancel();
    onUrlChanged.cancel();
    onStateChanged.cancel();
    onHttpError.cancel();
    onProgressChanged.cancel();
    onScrollXChanged.cancel();
    onScrollYChanged.cancel();
    afterHttpRequest.cancel();

    flutterWebViewPlugin.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    config = AppConfig.of(context);

    final Color backgroundColor = WebColor.getColor(widget.config.theme['primaryColor']);

    final MediaQueryData mediaContext = MediaQuery.of(context);
    double minorSize,centering;

    minorSize = mediaContext.size.width < mediaContext.size.height ? mediaContext.size.width : mediaContext.size.height;
    centering = minorSize / 4;

    Image logo = new Image.asset(
        'assets/launcher/foreground.png',
        width: minorSize * 0.15,
        height: minorSize * 0.15
    );

    final Container backgroundApp = Container(
        width: mediaContext.size.width,
        height: mediaContext.size.height,
        color: _loaded ? Colors.black : backgroundColor,
        child: Padding(
            padding: new EdgeInsets.only(
                top: (mediaContext.size.height - minorSize)  / 2 + centering ,
                left: (mediaContext.size.width - minorSize)  / 2 + centering,
                bottom: (mediaContext.size.height - minorSize)  / 2 + centering,
                right: (mediaContext.size.width - minorSize)  / 2 + centering
            ),
            child: _loaded ? null : logo
        )
    );

    final String mainDomain = config.domain;
    final String bearerToken = config.preferences.getString('token');

    Future<bool> _onHistoryBack() {
      //return new Future(() => false);
      debugPrint('History back allowed');
      return new Future(() => true);
    }

    return new WillPopScope(
        onWillPop: _onHistoryBack,
        child: Container(
            width: mediaContext.size.width,
            height: mediaContext.size.height,
            color: backgroundColor,
            child: Padding(
                padding: EdgeInsets.only(top: mediaContext.padding.top),
                child: WebviewScaffold(
                    url: widget.initialUrl,
                    userAgent: widget.config.baseUserAgent,
                    javascriptChannels: jsChannels,
                    headers: {
                      'Bearer-Token': bearerToken
                    },
                    withZoom: false,
                    hidden: true,
                    withLocalStorage: true,
                    invalidUrlRegex: r'^(?!(https?:\/\/(?:\w+\.)*\Q' + mainDomain + r'\E(\/\S*)*)$)',
                    validUrlHeaderRegex: r'^(https?:\/\/(?:\w+\.)*\Q' + mainDomain + r'\E\/pages(\/\S*)*)$',
                    initialChild: backgroundApp
                )
            )
        )
    );
  }
}