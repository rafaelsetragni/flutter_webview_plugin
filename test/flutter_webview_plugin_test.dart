import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_webview_plugin/imports.dart';
import 'package:mockito/mockito.dart';

void main() {
  MockMethodChannel methodChannel;
  FlutterWebviewPlugin webview;

  setUp(() {
    methodChannel = MockMethodChannel();
    webview = new FlutterWebviewPlugin.private(methodChannel);
  });


  group('Method channel invoke', () {
    test('Should invoke close', () async {
      webview.close();
      verify(methodChannel.invokeMethod('close')).called(1);
    });
    test('Should invoke reload', () async {
      webview.reload();
      verify(methodChannel.invokeMethod('reload')).called(1);
    });
    test('Should invoke goBack', () async {
      webview.goBack();
      verify(methodChannel.invokeMethod('back')).called(1);
    });
    test('Should invoke goForward', () async {
      webview.goForward();
      verify(methodChannel.invokeMethod('forward')).called(1);
    });
    test('Should invoke hide', () async {
      webview.hide();
      verify(methodChannel.invokeMethod('hide')).called(1);
    });
    test('Should invoke show', () async {
      webview.show();
      verify(methodChannel.invokeMethod('show')).called(1);
    });
  });
}

class MockMethodChannel extends Mock implements MethodChannel {}
