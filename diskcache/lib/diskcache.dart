import 'dart:async';

import 'package:flutter/services.dart';

class Diskcache {
  static const MethodChannel _channel =
      const MethodChannel('diskcache');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
