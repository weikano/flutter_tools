import 'package:flutter/material.dart';
import 'api.dart';
import 'const.dart';

class WeatherPage extends StatefulWidget {
  static var routeName = '/weather';

  @override
  State<StatefulWidget> createState() {
    return _WeatherState();
  }
}

class _WeatherState extends State<WeatherPage> {
  WeatherReport _report = WeatherReport.loading();

  @override
  void initState() {
    super.initState();
    _loadWeatherInfo();
  }

  void _loadWeatherInfo() async {
    var report = await getReport();
    setState(() {
      _report = report;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Code ${_report.status}"),
    );
  }
}
