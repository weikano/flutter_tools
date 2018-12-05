import 'package:flutter/material.dart';

class WeatherPage extends StatefulWidget {
  static var routeName = '/weather';

  @override
  State<StatefulWidget> createState() {
    return _WeatherState();
  }
}

class _WeatherState extends State<WeatherPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('没有实现'),
    );
  }
}
