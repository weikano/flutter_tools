import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tools/routes/gankio/main.dart';
import 'package:flutter_tools/routes/info/screen_info.dart';
import 'package:flutter_tools/routes/info/device_info.dart';
import 'package:flutter_tools/routes/weather/weather.dart';
import 'package:flutter_tools/routes/zhihu/zhihu.dart';
import 'package:flutter_tools/routes/gankio/gankio.dart';

class RouteData {
  const RouteData(
      {@required this.title,
      this.iconUrl,
      this.subTitle,
      @required this.routeName,
      @required this.builder});

  final String title;
  final String subTitle;
  final String routeName;
  final WidgetBuilder builder;
  final String iconUrl;
}

deviceIcon() {
  String icon;
  if (Platform.isWindows) {
    icon = 'device_windows';
  } else if (Platform.isAndroid) {
    icon = 'device_android';
  } else if (Platform.isIOS) {
    icon = 'device_ios';
  } else if (Platform.isLinux) {
    icon = 'device_linux';
  } else if (Platform.isMacOS) {
    icon = 'device_mac';
  } else {
    icon = 'device_other';
  }
  return 'assets/icons/$icon.png';
}

RouteData _screenInfo = RouteData(
  title: ScreenInfoPage.title,
  iconUrl: 'assets/icons/screen_info.png',
  builder: (BuildContext context) => ScreenInfoPage(),
  routeName: ScreenInfoPage.routeName,
);

RouteData _deviceInfo = RouteData(
  title: DeviceInfoPage.title,
  iconUrl: deviceIcon(),
  builder: (BuildContext context) => DeviceInfoPage(),
  routeName: DeviceInfoPage.routeName,
);

RouteData _weather = RouteData(
    title: WeatherPage.title,
    iconUrl: 'assets/icons/weather.png',
    routeName: WeatherPage.routeName,
    builder: (BuildContext context) => WeatherPage());

RouteData _zhihu = RouteData(
  title: ZhihuPage.title,
  iconUrl: 'assets/icons/zhihu.png',
  routeName: ZhihuPage.routeName,
  builder: (BuildContext context) => ZhihuPage(),
);

RouteData _gankio = RouteData(
  title: GankMainPage.title,
  iconUrl: 'assets/icons/gankio.png',
  routeName: GankIOPage.routeName,
  builder: (BuildContext context) => GankMainPage(),
);

final List<RouteData> allRoutes = _buildAllRoutes();

_buildAllRoutes() {
  return <RouteData>[
    _screenInfo,
    _deviceInfo,
    _weather,
    _zhihu,
    _gankio,
  ];
}
