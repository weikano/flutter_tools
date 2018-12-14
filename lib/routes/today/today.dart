import 'package:flutter/material.dart';
import 'package:flutter_tools/basic.dart';
import 'package:flutter_tools/routes/today/detail.dart';
import 'package:flutter_tools/widgets/commons.dart';
import 'const.dart';
import 'api.dart';

class EventsTodayPage extends StatefulWidget {
  static var routeName = '/weather';
  static var title = '历史上的今天';

  @override
  State<StatefulWidget> createState() {
    return _EventsTodayPageState();
  }
}

class _EventsTodayPageState extends StateWithFuture<EventsTodayPage> {
  ApiResponse<List<EventBrief>> _briefs = ApiResponse.ofLoading();
  DateTime _now = DateTime.now();

  void _loadData() async {
    _briefs = await today();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('${EventsTodayPage.title} - ${_now.month}月${_now.day}号'),
        ),
        body: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (_briefs.loading()) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (_briefs.fail()) {
      return Center(
        child: ReloadButton(
          onPressed: () {
            _loadData();
          },
        ),
      );
    } else {
      return _buildBriefsItemList(_briefs.response);
    }
  }

  Widget _buildBriefsItemList(List<EventBrief> response) {
    print(response.length);
    return ListView.builder(
      itemBuilder: (BuildContext _, int index) {
        var item = response[index];
        var content;
        if (item.img != null && item.img.length != 0) {
          content = Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 120,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Ink(
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      child: Image.network(
                        item.img,
                        height: 120,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Text('${item.date}-${item.title}'),
                  ),
                ],
              ),
            ),
          );
        } else {
          content = Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('${item.date}-${item.title}'),
          );
        }
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (BuildContext _) => EventDetailPage(item)),
            );
          },
          child: Card(
            child: content,
          ),
        );
      },
      itemCount: response.length,
    );
  }
}
