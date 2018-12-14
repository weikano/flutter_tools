import 'package:flutter_tools/converter/json_converter.dart';

//后面接日期参数，post方法或者get都可以 date=12/6
const TODAY =
    'https://api.shenjian.io/todayOnhistory/queryEvent?appid=b8c6de3bf9746a373237b2533617a9d7';
//后面接eid参数，post方法或者get都可以 为TODAY接口返回列表中的eid
const DETAIL =
    'https://api.shenjian.io/todayOnhistory/queryDetail/?appid=b8c6de3bf9746a373237b2533617a9d7';

class EventDetailImage {
  String pic_title;
  String url;
  EventDetailImage.fromJSON(Map<String, dynamic> json) {
    pic_title = optJSON(json, 'pic_title');
    url = optJSON(json, 'url');
  }
}

class EventDetail {
  String content;
  String eid;
  List<EventDetailImage> imgs;
  String title;

  EventDetail.fromJSON(Map<String, dynamic> json) {
    content = optJSON(json, 'content');
    eid = optJSON(json, 'eid');
    title = optJSON(json, 'title');
    List list = optJSON(json, 'imgs');
    imgs = list?.map((item) {
      return EventDetailImage.fromJSON(item);
    })?.toList();
  }
}

class EventBrief {
  String date;
  String day;
  String eid;
  String img;
  String title;

  EventBrief.fromJSON(Map<String, dynamic> json) {
    date = optJSON(json, 'date');
    day = optJSON(json, 'day');
    eid = optJSON(json, 'eid');
    img = optJSON(json, 'img');
    title = optJSON(json, 'title');
  }
}
