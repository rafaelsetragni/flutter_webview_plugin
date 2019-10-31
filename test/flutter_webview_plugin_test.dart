import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_webview_plugin/imports.dart';
import 'package:mockito/mockito.dart';

void main() {
  MockMethodChannel methodChannel;
  FlutterWebviewPlugin webView;

  setUp(() {
    methodChannel = MockMethodChannel();
    webView = new FlutterWebviewPlugin.private(methodChannel);
  });


  group('Method channel invoke', () {
    test('Should invoke close', () async {
      webView.close();
      verify(methodChannel.invokeMethod('close')).called(1);
    });
    test('Should invoke reload', () async {
      webView.reload();
      verify(methodChannel.invokeMethod('reload')).called(1);
    });
    test('Should invoke goBack', () async {
      webView.goBack();
      verify(methodChannel.invokeMethod('back')).called(1);
    });
    test('Should invoke goForward', () async {
      webView.goForward();
      verify(methodChannel.invokeMethod('forward')).called(1);
    });
    test('Should invoke hide', () async {
      webView.hide();
      verify(methodChannel.invokeMethod('hide')).called(1);
    });
    test('Should invoke show', () async {
      webView.show();
      verify(methodChannel.invokeMethod('show')).called(1);
    });
  });
}

class MockMethodChannel extends Mock implements MethodChannel {}
