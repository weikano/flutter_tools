import 'dart:convert' as decoder;

const HOST = "http://gank.io/api";
//最新一天的干货
const TODAY = '$HOST/today';
//闲读的主分类
const XIANDU_CATEGORY = '$HOST/xiandu/categories';
//闲读的子分类，category后面接收的参数为主分类返回的en_name
const XIANDU_CHILD = '$HOST/xiandu/category/wow';
//闲读的详细数据, id为闲读子分类id；page为第几页，从1开始；count为每页的个数
const XIANDU_DATA = "$HOST/xiandu/data/id/appinn/count/10/page/1";
//搜索category后面接收参数all|Android|iOS|休息视频|福利|前端|瞎推荐|App；count最大为50
const SEARCH = '$HOST/search/query/listview/category/Android/count/10/page/1';
//获取某几日干货网站数据, 2代表2个数据，1代表取第一页数据
const HISTORY = '$HOST/history/content/2/1';
const HISTORY_SPECIFIC = '$HOST/history/content/day/2016/05/11';
//获取发过干货日期接口
const DAY_HISTORY = '$HOST/day/history';
//每日数据
const DAILY = '$HOST/day/2015/08/06';
//随机数据
const RANDOM = '$HOST/random/data/Android/20';

//XIANDU_CATEGORY
class Category {
  final String id;
  final String code;
  final String name;
  final int rank;

  Category.fromJSON(Map<String, dynamic> json)
      : id = json['_id'],
        code = json['en_name'],
        name = json['name'],
        rank = json['rank'];
}

//XIANDU_CHILD
class SubCategory {
  final String id;
  final String date;
  final String icon;
  final String code;
  final String title;

  SubCategory.fromJSON(Map<String, dynamic> json)
      : id = json['_id'],
        date = json['created_at'],
        icon = json['icon'],
        code = json['id'],
        title = json['title'];
}

//XIANDU_DATA
class DataRawOrigin {
  final String streamId;
  final String title;
  final String htmlUrl;
  DataRawOrigin.fromJSON(Map<String, dynamic> json)
      : streamId = json['streamId'],
        title = json['title'],
        htmlUrl = json['html'];
}

class DataRawAlternate {
  final String href;
  final String type;
  DataRawAlternate.fromJSON(Map<String, dynamic> json)
      : href = json['href'],
        type = json['type'];
}

class DataRawSummary {
  final String content;
  final String direction;
  DataRawSummary.fromJSON(Map<String, dynamic> json)
      : content = json['content'],
        direction = json['direction'];
}

class DataRawVisual {
  final String url;
  DataRawVisual.fromJSON(Map<String, dynamic> json) : url = json['url'];
}

class DataRaw {
  final String id;
  final String originId;
  final String fingerprint;
  final String title;
  final int crawled;
  final int publishedAt;
  final DataRawSummary summary;
  final DataRawOrigin origin;
  List<DataRawAlternate> alternate;
  final DataRawVisual visual;
  final bool unread;

  DataRaw.fromJSON(Map<String, dynamic> json)
      : id = json['id'],
        originId = json['originId'],
        fingerprint = json['fingerprint'],
        title = json['title'],
        crawled = json['crawled'],
        publishedAt = json['published'],
        summary = DataRawSummary.fromJSON(json['summary']),
        origin = DataRawOrigin.fromJSON(json['origin']),
        visual = DataRawVisual.fromJSON(json['visual']),
        unread = json['unread'] {
    List data = json['alternate'];
    alternate = data.map((m) => DataRawAlternate.fromJSON(m)).toList();
  }
}

class DataSite {
  final String catName;
  final String catCode;
  final String desc;
  final String feedId;
  final String icon;
  final String id;
  final String name;
  final int subscribers;
  final String type;
  final String url;

  DataSite.fromJSON(Map<String, dynamic> json)
      : catName = json['cat_cn'],
        catCode = json['cat_en'],
        desc = json['desc'],
        feedId = json['feed_id'],
        icon = json['icon'],
        id = json['id'],
        name = json['name'],
        subscribers = json['subscribers'],
        type = json['type'],
        url = json['url'];
}

class Data {
  final String id;
  final String content;
  final String cover;
  final int crawled;
  final String createdAt;
  final bool deleted;
  final String publishedAt;
  DataRaw raw;
  List<DataSite> sites;
  final String title;
  final String uid;
  final String url;
  Data.fromJSON(Map<String, dynamic> json)
      : id = json['_id'],
        content = json['content'],
        cover = json['cover'],
        crawled = json['crawled'],
        createdAt = json['created_at'],
        deleted = json['deleted'],
        publishedAt = json['published_at'],
        title = json['title'],
        uid = json['uid'],
        url = json['url'] {
    List sitesData = json['site'];
    sites = sitesData.map((m) => DataSite.fromJSON(m)).toList();
    Map<String, dynamic> rawJson = decoder.json.decode(json['raw']);
    raw = DataRaw.fromJSON(rawJson);
  }
}

//SEARCH
class SearchResult {
  final String desc;
  final int id;
  final String publishedAt;
  final readability;
  final String type;
  final String url;
  final String who;
  SearchResult.fromJSON(Map<String, Object> json)
      : desc = json['desc'],
        id = json['ganhuo_id'],
        publishedAt = json['publishedAt'],
        readability = json['readability'],
        type = json['type'],
        url = json['url'],
        who = json['who'];
}
//
