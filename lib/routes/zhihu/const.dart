import 'package:flutter_tools/converter/json_converter.dart';

//启动界面图像
const LAUNCH_IMAGE =
    'https://news-at.zhihu.com/api/7/fetch-launch-images/1080*1920';
const NEWS = 'https://news-at.zhihu.com/api/4/news/latest';

class Story {
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

class TopStory {
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
