import 'package:flutter/material.dart';
import 'package:flutter_tools/basic.dart';
import 'package:flutter_tools/widgets/commons.dart';

import 'const.dart';
import 'api.dart';

class EventDetailPage extends StatefulWidget {
  EventDetailPage(this.event);

  final EventBrief event;

  @override
  State<StatefulWidget> createState() {
    return _EventDetailState();
  }
}

class _EventDetailState extends StateWithFuture<EventDetailPage> {
  ApiResponse<EventDetail> _data = ApiResponse<EventDetail>.ofLoading();
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    _data = await detail(widget.event.eid);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.event.title),
          leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: _buildDetail(),
      ),
    );
  }

  Widget _buildDetail() {
    if (_data.loading()) {
      return LoadingIndicator();
    } else if (_data.fail()) {
      return ReloadButton(
        onPressed: () {
          _data = ApiResponse.ofLoading();
          setState(() {});
          _loadData();
        },
      );
    } else {
      return _buildDetailContent(_data.response);
    }
  }

  final ScrollController _controller = ScrollController();
  double itemExtend = 180;
  Widget _buildDetailContent(EventDetail response) {
    return SingleChildScrollView(
      controller: _controller,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(response.content),
          ),
          _buildImageContainer(response.imgs),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }

  Widget _buildImageContainer(List<EventDetailImage> imgs) {
    if (imgs != null) {
      if (imgs.length == 1) {
        return Center(
          child: Image.network(
            imgs[0].url,
            height: itemExtend,
            fit: BoxFit.fitHeight,
          ),
        );
      } else {
        return Center(
          child: SizedBox(
            height: itemExtend,
            child: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                if (index == 0 || index == imgs.length + 1) {
                  return SizedBox(
                    width: 12,
                  );
                } else {
                  return Image.network(
                    imgs[index - 1].url,
                    height: itemExtend,
                    fit: BoxFit.fitHeight,
                  );
                }
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  width: 20,
                );
              },
              itemCount: imgs.length + 2,
              scrollDirection: Axis.horizontal,
            ),
          ),
        );
      }
    }
    return Container();
  }
}
