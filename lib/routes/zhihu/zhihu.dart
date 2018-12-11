import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math';
import 'const.dart';
import 'api.dart';
import 'zhihu_item.dart';
import 'package:flutter_tools/basic.dart';

class ZhihuPage extends StatefulWidget {
  static var routeName = '/zhihu';
  static var title = '知乎日报';

  @override
  State<StatefulWidget> createState() {
    return _ZhihuState();
  }
}

class _ZhihuState extends StateWithFuture<ZhihuPage> {
  PageController _controller;
  ScrollController _scroller;
  double scrollHeight;
  double _currentPixel = 0;
  News _news;

  @override
  void initState() {
    super.initState();
    scrollHeight =
        window.physicalSize.width / (16.0 / 9.0) / window.devicePixelRatio -
            kToolbarHeight -
            24;
    _scroller = ScrollController();
    _loadData();
  }

  Future<void> _loadData() async {
    _news = await news();
    setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    _scroller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData data = MediaQuery.of(context);

    return MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: Material(
        child: Stack(
          children: <Widget>[
            _news == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : _buildStories(_news, _onScrolled),
            Container(
              color: Colors.blue.withAlpha(
                  1.0 * 255 * min(scrollHeight, _currentPixel) ~/ scrollHeight),
              child: SizedBox(
                height: kToolbarHeight + data.padding.top,
                child: Container(
                  margin: EdgeInsets.only(top: data.padding.top),
                  child: AppBar(
                    title: Text(ZhihuPage.title),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _onScrolled(ScrollUpdateNotification notification) {
    if (notification.metrics.axisDirection == AxisDirection.up ||
        notification.metrics.axisDirection == AxisDirection.down) {
      setState(() {
        _currentPixel = notification.metrics.pixels;
      });
    }
    return true;
  }

  Widget _buildStories(News data,
      NotificationListenerCallback<ScrollUpdateNotification> notification) {
    return NotificationListener(
      onNotification: notification,
      child: RefreshIndicator(
        onRefresh: _loadData,
        child: ListView.builder(
          controller: _scroller,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return _buildTopStories(data);
            }
            var story = data.stories[index - 1];
            return SizedBox(
              height: 80,
              child: InkWell(
                excludeFromSemantics: true,
                onTap: () {
                  _jumpToStory(story);
                },
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          story.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      AspectRatio(
                        aspectRatio: 16.0 / 9.0,
                        child: Image.network(
                          story.images[0],
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          itemCount: data.stories.length + 1,
        ),
      ),
    );
  }

  Widget _buildTopStories(News data) {
    _controller = PageController(initialPage: data.topStories.length * 50 + 1);
    return AspectRatio(
      aspectRatio: 16.0 / 9.0,
      child: PageView.builder(
          itemCount: data.topStories.length * 100,
          controller: _controller,
          itemBuilder: (BuildContext context, int index) {
            var item = data.topStories[index % data.topStories.length];
            return GestureDetector(
              onTap: () {
                _jumpToStory(item);
              },
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(item.image),
                    fit: BoxFit.fitWidth,
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0)
                        .copyWith(bottom: 24.0),
                    child: Text(
                      item.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(2.0, 2.0),
                            blurRadius: 3.0,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                          Shadow(
                            offset: Offset(2.0, 2.0),
                            blurRadius: 8.0,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  _jumpToStory(ZhihuItem item) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return ZhihuItemPage(
        item: item,
      );
    }));
//    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
//      return ZhihuItemPage(
//        item: item,
//      );
//    }));
  }
}
