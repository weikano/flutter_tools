import 'dart:convert' as decoder;
import 'package:flutter_tools/converter/json_converter.dart' as CONVERTER;

const HOST = "http://gank.io/api";
//最新一天的干货
const TODAY = '$HOST/today';
//闲读的主分类
const XIANDU_CATEGORY = '$HOST/xiandu/categories';
//闲读的子分类，category后面接收的参数为主分类返回的en_name
const XIANDU_CHILD = '$HOST/xiandu/category/';
//闲读的详细数据, id为闲读子分类id；page为第几页，从1开始；count为每页的个数
const XIANDU_DATA = "$HOST/xiandu/data/id/appinn/count/10/page/1";
//搜索category后面接收参数all|Android|iOS|休息视频|福利|前端|瞎推荐|App；count最大为50
const SEARCH = '$HOST/search/query/listview/category/Android/count/10/page/1';
//获取某几日干货网站数据, 2代表2个数据，1代表取第一页数据
const HISTORY = '$HOST/history/content/2/1';
const HISTORY_SPECIFIC = '$HOST/history/content/day/2016/05/11';
//获取发过干货的日期的接口，返回数据为yyyy-mm-dd的json列表，可以用在下面的每日数据中
const DAY_HISTORY = '$HOST/day/history';
//每日数据
const DAILY = '$HOST/day/2015/08/06';
//随机数据
const RANDOM = '$HOST/random/data/Android/20';

List<Category> kCategories = _buildCategories();

List<Category> _buildCategories() {
  return <Category>[
    Category(
      id: '57c83777421aa97cbd81c74d',
      code: 'wow',
      name: '科技资讯',
      rank: 1,
    ),
    Category(
      id: '57c83577421aa97cb162d8b1',
      code: 'apps',
      name: '趣味软件/游戏',
      rank: 5,
    ),
    Category(
      id: '57c83627421aa97cbd81c74b',
      code: 'imrich',
      name: '装备党',
      rank: 50,
    ),
    Category(
      id: '57c836b4421aa97cbd81c74c',
      code: 'funny',
      name: '草根新闻',
      rank: 100,
    ),
    Category(
      id: '5827dc81421aa911e32d87cc',
      code: 'android',
      name: 'Android',
      rank: 300,
    ),
    Category(
      id: '582c5346421aa95002741a8e',
      code: 'diediedie',
      name: '创业新闻',
      rank: 340,
    ),
    Category(
      id: '5829c2bc421aa911e32d87e7',
      code: 'thinking',
      name: '独立思想',
      rank: 400,
    ),
    Category(
      id: '5827dd7b421aa911d3bb7eca',
      code: 'iOS',
      name: 'iOS',
      rank: 500,
    ),
    Category(
      id: '5829b881421aa911dbc9156b',
      code: 'teamblog',
      name: '团队博客',
      rank: 600,
    ),
  ];
}

//XIANDU_CATEGORY
class Category {
  String id;
  String code;
  String name;
  int rank;

  Category({this.id, this.code, this.name, this.rank});

  Category.fromJSON(Map<String, dynamic> json)
      : id = CONVERTER.optJSON(json, '_id'),
        code = CONVERTER.optJSON(json, 'en_name'),
        name = CONVERTER.optJSON(json, 'name'),
        rank = CONVERTER.optJSON(json, 'rank');
}

//XIANDU_CHILD
class SubCategory {
  String id;
  String date;
  String icon;
  String code;
  String title;

  SubCategory.fromJSON(Map<String, dynamic> json) {
    id = CONVERTER.optJSON(json, '_id');
    date = CONVERTER.optJSON(json, 'created_at');
    icon = CONVERTER.optJSON(json, 'icon');
    code = CONVERTER.optJSON(json, 'id');
    title = CONVERTER.optJSON(json, 'title');
  }
}

//XIANDU_DATA
class DataRawOrigin {
  String streamId;
  String title;
  String htmlUrl;

  DataRawOrigin.fromJSON(Map<String, dynamic> json)
      : streamId = CONVERTER.optJSON(json, 'streamId'),
        title = CONVERTER.optJSON(json, 'title'),
        htmlUrl = CONVERTER.optJSON(json, 'html');
}

class DataRawAlternate {
  String href;
  String type;

  DataRawAlternate.fromJSON(Map<String, dynamic> json)
      : href = CONVERTER.optJSON(json, 'href'),
        type = CONVERTER.optJSON(json, 'type');
}

class DataRawSummary {
  String content;
  String direction;

  DataRawSummary.fromJSON(Map<String, dynamic> json)
      : content = CONVERTER.optJSON(json, 'content'),
        direction = CONVERTER.optJSON(json, 'direction');
}

class DataRawVisual {
  String url;

  DataRawVisual.fromJSON(Map<String, dynamic> json)
      : url = CONVERTER.optJSON(json, 'url');
}

class DataRaw {
  String id;
  String originId;
  String fingerprint;
  String title;
  int crawled;
  int publishedAt;
  DataRawSummary summary;
  DataRawOrigin origin;
  List<DataRawAlternate> alternate;
  DataRawVisual visual;
  bool unread;

  DataRaw.fromJSON(Map<String, dynamic> json)
      : id = CONVERTER.optJSON(json, 'id'),
        originId = CONVERTER.optJSON(json, 'originId'),
        fingerprint = CONVERTER.optJSON(json, 'fingerprint'),
        title = CONVERTER.optJSON(json, 'title'),
        crawled = CONVERTER.optJSON(json, 'crawled'),
        publishedAt = CONVERTER.optJSON(json, 'published'),
        summary = DataRawSummary.fromJSON(CONVERTER.optJSON(json, 'summary')),
        origin = DataRawOrigin.fromJSON(CONVERTER.optJSON(json, 'origin')),
        visual = DataRawVisual.fromJSON(CONVERTER.optJSON(json, 'visual')),
        unread = CONVERTER.optJSON(json, 'unread') {
    List data = CONVERTER.optJSON(json, 'alternate');
    alternate = data.map((m) => DataRawAlternate.fromJSON(m)).toList();
  }
}

class DataSite {
  String catName;
  String catCode;
  String desc;
  String feedId;
  String icon;
  String id;
  String name;
  int subscribers;
  String type;
  String url;

  DataSite.fromJSON(Map<String, dynamic> json)
      : catName = CONVERTER.optJSON(json, 'cat_cn'),
        catCode = CONVERTER.optJSON(json, 'cat_en'),
        desc = CONVERTER.optJSON(json, 'desc'),
        feedId = CONVERTER.optJSON(json, 'feed_id'),
        icon = CONVERTER.optJSON(json, 'icon'),
        id = CONVERTER.optJSON(json, 'id'),
        name = CONVERTER.optJSON(json, 'name'),
        subscribers = CONVERTER.optJSON(json, 'subscribers'),
        type = CONVERTER.optJSON(json, 'type'),
        url = CONVERTER.optJSON(json, 'url');
}

class Data {
  String id;
  String content;
  String cover;
  int crawled;
  String createdAt;
  bool deleted;
  String publishedAt;
  DataRaw raw;
  List<DataSite> sites;
  String title;
  String uid;
  String url;

  Data.fromJSON(Map<String, dynamic> json)
      : id = CONVERTER.optJSON(json, '_id'),
        content = CONVERTER.optJSON(json, 'content'),
        cover = CONVERTER.optJSON(json, 'cover'),
        crawled = CONVERTER.optJSON(json, 'crawled'),
        createdAt = CONVERTER.optJSON(json, 'created_at'),
        deleted = CONVERTER.optJSON(json, 'deleted'),
        publishedAt = CONVERTER.optJSON(json, 'published_at'),
        title = CONVERTER.optJSON(json, 'title'),
        uid = CONVERTER.optJSON(json, 'uid'),
        url = CONVERTER.optJSON(json, 'url') {
    List sitesData = CONVERTER.optJSON(json, 'site');
    sites = sitesData.map((m) => DataSite.fromJSON(m)).toList();
    Map<String, dynamic> rawJson =
        decoder.json.decode(CONVERTER.optJSON(json, 'raw'));
    raw = DataRaw.fromJSON(rawJson);
  }
}

//SEARCH
class SearchResult {
  String desc;
  int id;
  String publishedAt;
  String readability;
  String type;
  String url;
  String who;

  SearchResult.fromJSON(Map<String, Object> json) {
    desc = CONVERTER.optJSON(json, 'desc');
    id = CONVERTER.optJSON(json, 'ganhuo_id');
    publishedAt = CONVERTER.optJSON(json, 'publishedAt');
    readability = CONVERTER.optJSON(json, 'readability');
    type = CONVERTER.optJSON(json, 'type');
    url = CONVERTER.optJSON(json, 'url');
    who = CONVERTER.optJSON(json, 'who');
  }
}

//HISTORY and HISTORY_SPECIFIC
class History {
  String id;
  String content;
  String createdAt;
  String publishedAt;
  String randId;
  String title;
  String updatedAt;

  History.fromJSON(Map<String, dynamic> json) {
    id = CONVERTER.optJSON(json, '_id');
    content = CONVERTER.optJSON(json, 'content');
    createdAt = CONVERTER.optJSON(json, 'created_at');
    publishedAt = CONVERTER.optJSON(json, 'publishedAt');
    randId = CONVERTER.optJSON(json, 'rand_id');
    title = CONVERTER.optJSON(json, 'title');
    updatedAt = CONVERTER.optJSON(json, 'updated_at');
  }
}

class DailyItem {
  String id;
  String createdAt;
  String desc;
  List<String> images;
  String publishedAt;
  String source;
  String type;
  String url;
  bool used;
  String who;

  DailyItem.fromJSON(Map<String, dynamic> json)
      : id = CONVERTER.optJSON(json, '_id'),
        createdAt = CONVERTER.optJSON(json, 'createdAt'),
        desc = CONVERTER.optJSON(json, 'desc'),
        publishedAt = CONVERTER.optJSON(json, 'publishedAt'),
        source = CONVERTER.optJSON(json, 'source'),
        type = CONVERTER.optJSON(json, 'type'),
        url = CONVERTER.optJSON(json, 'url'),
        used = CONVERTER.optJSON(json, 'used'),
        who = CONVERTER.optJSON(json, 'who') {
    List list = CONVERTER.optJSON(json, 'images');
    images = list?.map((m) => m.toString())?.toList();
  }
}

//DAILY
class Daily {
  Map<String, List<DailyItem>> dailyItems;

  Daily.fromJSON(Map<String, dynamic> json) {
    List category = CONVERTER.optJSON(json, 'category');
    Map<String, dynamic> results = CONVERTER.optJSON(json, 'results');
    if (category != null && results != null) {
      category.map((m) {
        String key = m.toString();
        List data = CONVERTER.optJSON(results, key);
        if (data != null) {
          dailyItems[key] =
              data.map((data) => DailyItem.fromJSON(data)).toList();
        }
      });
    }
  }
}

//RANDOM
class Random {
  List<DailyItem> items;

  Random.fromJSON(Map<String, dynamic> json) {
    List results = CONVERTER.optJSON(json, 'results');
    if (results != null) {
      items = results.map((m) => DailyItem.fromJSON(m)).toList();
    }
  }
}
