import 'package:flutter/material.dart';
import 'package:flutter_tools/routes/poet/const_fix.dart';

//todo 诗词详情显示，参考诗词之美
///详情显示
class PoetDetailPageFix extends StatelessWidget {
  final _From from;
  final dynamic data;
  PoetDetailPageFix.fromQuote(this.data) : from = _From.fromQuote;
  PoetDetailPageFix.fromWork(this.data) : from = _From.fromWork;
  @override
  Widget build(BuildContext context) {
    if (from == _From.fromQuote) {
      return _BodyFromQuote(data as CollectionQuote);
    } else {
      return _BodyFromWork.factory((data as CollectionWork).work_id);
    }
  }
}

//todo 从摘录id找到对应的诗词详情
///根据quote_id从collection_quotes中找到对应的work_id，然后从works里面找到对应的work
class _BodyFromQuote extends StatefulWidget {
  final CollectionQuote data;
  _BodyFromQuote(this.data);
  @override
  State<StatefulWidget> createState() {
    return _BodyFromQuoteState();
  }
}

class _BodyFromQuoteState extends State<_BodyFromQuote> {
  @override
  Widget build(BuildContext context) {
    return null;
  }
}

//todo 直接根据work_id找到对应的诗词详情
///根据work_id找到works中的work
class _BodyFromWork extends StatefulWidget {
  final int id;
  _BodyFromWork.factory(this.id);
  @override
  State<StatefulWidget> createState() {
    return _BodyFromWorkState();
  }
}

class _BodyFromWorkState extends State<_BodyFromWork> {
  @override
  Widget build(BuildContext context) {
    return null;
  }
}

///从哪点进来
enum _From { fromWork, fromQuote }
