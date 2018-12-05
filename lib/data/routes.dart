import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tools/routes/info/screen_info.dart';
import 'package:flutter_tools/routes/info/device_info.dart';
import 'package:flutter_tools/routes/weather/weather.dart';

class RouteData {
  const RouteData(
      {@required this.title,
      this.icon,
      this.subTitle,
      @required this.routeName,
      @required this.builder});

  final String title;
  final IconData icon;
  final String subTitle;
  final String routeName;
  final WidgetBuilder builder;
}

RouteData _screenInfo = RouteData(
  title: '屏幕信息',
  subTitle: '屏幕分辨率等信息',
  icon: Platform.isIOS
      ? Icons.phone_iphone
      : (Platform.isAndroid ? Icons.phone_android : Icons.device_unknown),
  builder: (BuildContext context) {
    return ScreenInfoPage();
  },
  routeName: ScreenInfoPage.routeName,
);

RouteData _deviceInfo = RouteData(
  title: '关于手机',
  subTitle: '手机系统配置等信息',
  icon: Icons.info,
  builder: (BuildContext context) {
    return DeviceInfoPage();
  },
  routeName: DeviceInfoPage.routeName,
);

RouteData _weather = RouteData(
    title: "天气预报",
    icon: Icons.data_usage,
    routeName: WeatherPage.routeName,
    builder: (BuildContext context) => WeatherPage());

final List<RouteData> allRoutes = _buildAllRoutes();

_buildAllRoutes() {
  return <RouteData>[
    _screenInfo,
    _deviceInfo,
    _weather,
  ];
}
