import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin_example/config/app_config.dart';
import 'package:meta/meta.dart';

import 'package:device_info/device_info.dart';
import 'package:package_info/package_info.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AppConfig extends InheritedWidget {

  AppConfig({
    @required this.appName,
    @required this.appId,
    @required this.packageName,
    @required this.version,
    @required this.buildNumber,
    @required this.flavorName,
    @required this.domain,
    @required this.oAuthIds,
    @required this.startsWithHttps,
    @required this.theme,
    @required this.baseUserAgent,
    @required this.preferences,
    @required Widget child,
    // @required this.userConfig
  }) : super(child: child);

  final String appName;
  final String appId;
  final String packageName;
  final String version;
  final String buildNumber;
  final String flavorName;
  final String domain;
  final Map<String, String> oAuthIds;
  final bool startsWithHttps;
  final Map<String, String> theme;
  final String baseUserAgent;
  final SharedPreferences preferences;
  //final SharedPreferences userConfig;

  static AppConfig of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(AppConfig);
  }

  String getFullDomainUrl(){
    return ( startsWithHttps ? 'https://' : 'http://' ) + domain;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  static Future<AppConfig> getConfig(Widget firstPage) async {

    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

    final String appName = packageInfo.appName;
    final String packageName = packageInfo.packageName;
    final String version = packageInfo.version;
    final String buildNumber = packageInfo.buildNumber;
    final String userAgentApp = appName.replaceAll(' ', '_');

    String baseUserAgent;
    if (Platform.isAndroid) {
        final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        baseUserAgent = '${userAgentApp}/${buildNumber} (Linux; Flutter/${androidInfo.version.sdkInt}; Android ${androidInfo.version.release}; ${androidInfo.model} Build/${androidInfo.id})';
    } else
    if (Platform.isIOS) {
        final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        baseUserAgent = '${userAgentApp}/${buildNumber} (${iosInfo.utsname.release}; ${iosInfo.utsname.machine})';
    }
    return new AppConfig(
        appName: appName+' DEV',
        appId:   packageName,
        buildNumber: buildNumber,
        packageName: packageName,
        version: version,
        baseUserAgent: baseUserAgent,
        flavorName:      BASIC_APP_CONFIG['enviroment'],
        domain:          BASIC_APP_CONFIG['domain'],
        startsWithHttps: BASIC_APP_CONFIG['https'],
        theme:           BASIC_APP_CONFIG['theme'],
        oAuthIds:        BASIC_APP_CONFIG['oAuthIds'],
        preferences: await SharedPreferences.getInstance(),
        child: firstPage,
    );
  }
}