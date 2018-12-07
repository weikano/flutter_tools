import 'package:flutter/material.dart';
import 'api.dart';
import 'const.dart';

class WeatherPage extends StatefulWidget {
  static var routeName = '/weather';
  static var title = '天气预报';

  @override
  State<StatefulWidget> createState() {
    return _WeatherState();
  }
}

class _WeatherState extends State<WeatherPage> {
  WeatherReport _report = WeatherReport.ofLoading();

  Future<WeatherReport> _loadWeatherInfo() async {
    return getReportTest();
  }

  Widget _buildNow() {
    final Daily today = _report.dailyReports[0];
    //todo 考虑用Table实现
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: <Widget>[
          Text(
              '今天: 现在${today.dayCodeDesc}。最高气温${today.maxTmp}。今晚大部${today.nightCodeDesc},最低气温${today.minTmp}'),
          Divider(
            height: 6,
          ),
          _buildNowSection('日出时间', today.sr, '日落时间', today.ss),
          _buildNowSection('月升时间', today.mr, '月落时间', today.ms),
          _buildNowSection('降雨概率', '${today.pop}%', '湿度', '${today.hum}%'),
          _buildNowSection('降水量', '${today.pcpn}毫升', '气压', '${today.pres}百帕'),
          _buildNowSection(
              '能见度', '${today.vis}公里', '紫外线指数', '${today.indexUv}'),
        ],
      ),
    );
  }

  Widget _buildNowSection(
      String label1, dynamic value1, String label2, dynamic value2) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Text(
                    label1,
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    value1.toString(),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Text(
                    label2,
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    value2.toString(),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            )
          ],
        ),
        Divider(
          height: 4.0,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '天气预报',
      home: Scaffold(
        body: FutureBuilder(
          builder:
              (BuildContext context, AsyncSnapshot<WeatherReport> snapshot) {
            if (snapshot.hasError) {
              return _buildErrorPage();
            } else if (snapshot.hasData) {
              _report = snapshot.data;
              if (_report.loading()) {
                return _buildLoading();
              } else if (_report.success()) {
                return _buildContent();
              }
            }
            return _buildLoading();
          },
          future: _loadWeatherInfo(),
          initialData: WeatherReport.ofLoading(),
        ),
        floatingActionButton: _report.success()
            ? FloatingActionButton(
                child: Icon(Icons.refresh),
                onPressed: _loadWeatherInfo,
              )
            : null,
      ),
    );
  }

  Widget _buildErrorPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.error,
          size: 60,
          color: Colors.red,
        ),
        RaisedButton(
          child: Text('重试'),
          onPressed: _loadWeatherInfo,
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildContent() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              }),
          pinned: true,
//            expandedHeight: 200,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(_report.basic.location),
          ),
        ),
        SliverToBoxAdapter(
          child: _buildNow(),
        ),
//          SliverPersistentHeader(delegate: null),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          sliver: SliverFixedExtentList(
            itemExtent: 30,
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              final Daily daily = _report.dailyReports[index];
              final int weekday = DateTime.parse(daily.date).weekday;
              return Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('星期$weekday'),
                    Text(daily.dayCodeDesc),
                    Text(daily.maxTmp.toString()),
                    Text(daily.minTmp.toString()),
                  ],
                ),
              );
            }, childCount: _report.dailyReports.length),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          sliver: SliverFixedExtentList(
            itemExtent: 100,
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            LIFESTYLES[_report.lifestyles[index].type],
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              _report.lifestyles[index].brief,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 6,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        _report.lifestyles[index].desc,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }, childCount: _report.lifestyles.length),
          ),
        )
      ],
    );
  }
}
