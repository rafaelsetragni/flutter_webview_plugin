import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

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
}