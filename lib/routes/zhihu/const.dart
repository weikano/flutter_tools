import 'package:flutter_tools/converter/json_converter.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

//启动界面图像
const LAUNCH_IMAGE =
    'https://news-at.zhihu.com/api/7/fetch-launch-images/1080*1920';
const NEWS = 'https://news-at.zhihu.com/api/4/news/latest';
const CONTENT = 'https://news-at.zhihu.com/api/4/news';

abstract class ZhihuItem {
  String get title;

  int get id;

  int get type;
}

class Story extends ZhihuItem {
  List<String> images;
  String title;
  int type;
  int id;

  Story.fromJSON(Map<String, dynamic> json) {
    title = optJSON(json, 'title');
    type = optJSON(json, 'type');
    id = optJSON(json, 'id');
    List list = optJSON(json, 'images');
    images = list?.map((m) => m.toString())?.toList();
  }
}

class TopStory extends ZhihuItem {
  String title;
  String image;
  int type;
  int id;

  TopStory.fromJSON(Map<String, dynamic> json) {
    title = optJSON(json, 'title');
    image = optJSON(json, 'image');
    type = optJSON(json, 'type');
    id = optJSON(json, 'id');
  }
}

class News {
  String date;
  List<Story> stories;
  List<TopStory> topStories;

  News.fromJSON(Map<String, dynamic> json) {
    date = optJSON(json, 'date');
    List list = optJSON(json, 'stories');
    stories = list?.map((m) => Story.fromJSON(m))?.toList();
    list = optJSON(json, 'top_stories');
    topStories = list?.map((m) => TopStory.fromJSON(m))?.toList();
  }
}

enum ContentPType {
  pic,
  text,
}

class NewsContentP {
  ContentPType type;
  String content;
  NewsContentP.image(String url) {
    type = ContentPType.pic;
    content = url;
  }

  NewsContentP.text(String text) {
    type = ContentPType.text;
    content = text;
  }
}

class NewsContentDetail {
  String questionTitle; //h2 class=question-title
  String avatar; //img class=avatar
  String author; //span class=author
  String bio; //span class=bio
  List<NewsContentP> ps; //div class=content中每个p为一个NewsContentP
  NewsContentDetail.fromDocument(Document document) {
    questionTitle = document.getElementsByClassName('question-title')[0].text;
    print(questionTitle);
    avatar = document.getElementsByClassName('avatar')[0].attributes['src'];
    print(avatar);
    author = document.getElementsByClassName('author')[0].text;

    print(author);

    bio = document.getElementsByClassName('bio')[0].text;
    print(bio);
    Element raw = document.getElementsByClassName('content')[0];
    var paras = raw.getElementsByTagName('p');
    ps = paras.map((para) {
      var images = para.getElementsByClassName('content-image');
      if (images != null && images.isNotEmpty) {
        return NewsContentP.image(images[0].attributes['src']);
      } else {
        return NewsContentP.text(para.text);
      }
    }).toList();
  }
}

class NewsContent {
  String body;
  String imageSource;
  String title;
  String image;
  String shareUrl;
  List<String> js;
  List<String> images;
  int type;
  int id;
  List<String> css;
  NewsContentDetail parsed;

  NewsContent.fromJSON(Map<String, dynamic> json) {
    body = optJSON(json, 'body');
    imageSource = optJSON(json, 'image_source');
    image = optJSON(json, 'image');
    title = optJSON(json, 'title');
    shareUrl = optJSON(json, 'shareUrl');
    List list = optJSON(json, 'js');
    js = list?.map((m) => m.toString())?.toList();
    list = optJSON(json, 'images');
    images = list?.map((m) => m.toString())?.toList();
    type = optJSON(json, 'type');
    id = optJSON(json, 'id');
    list = optJSON(json, 'css');
    css = list?.map((m) => m.toString())?.toList();

    var document = parse(body);
    parsed = NewsContentDetail.fromDocument(document);
  }
}
