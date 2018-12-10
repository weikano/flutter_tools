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

  Widget _buildTableCell(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(label),
          SizedBox(
            height: 4,
          ),
          Text(value.toString()),
        ],
      ),
    );
  }

  Widget _buildNow() {
    final Daily today = _report.dailyReports[0];
    //todo 考虑用Table实现
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Table(
        border: TableBorder.all(
//          color: Colors.transparent,
//          width: 20,
            ),
        children: <TableRow>[
          TableRow(
            children: <TableCell>[
              TableCell(
                child: _buildTableCell('日出时间', today.sr),
              ),
              TableCell(
                child: _buildTableCell('日落时间', today.ss),
              )
            ],
          ),
          TableRow(
            children: <TableCell>[
              TableCell(
                child: _buildTableCell('月升时间', today.mr),
              ),
              TableCell(
                child: _buildTableCell('月落时间', today.ms),
              ),
            ],
          ),
          TableRow(
            children: <TableCell>[
              TableCell(
                child: _buildTableCell('降雨概率', '${today.pop}%'),
              ),
              TableCell(
                child: _buildTableCell('湿度', '${today.hum}%'),
              ),
            ],
          ),
          TableRow(
            children: <TableCell>[
              TableCell(
                child: _buildTableCell('降水量', '${today.pcpn}毫升'),
              ),
              TableCell(
                child: _buildTableCell('气压', '${today.pres}百帕'),
              ),
            ],
          ),
          TableRow(
            children: <TableCell>[
              TableCell(
                child: _buildTableCell('能见度', '${today.vis}公里'),
              ),
              TableCell(
                child: _buildTableCell('紫外线指数', '${today.indexUv}'),
              ),
            ],
          ),
        ],
      ),
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
