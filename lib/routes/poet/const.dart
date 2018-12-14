import 'package:flutter_tools/converter/json_converter.dart';

const ONE = 'https://v2.jinrishici.com/one.json';
const TOKEN = 'https://v2.jinrishici.com/token';

const TOKEN_KEY = 'poetry-token-key';

class PoetryOrigin {
  String title; //标题
  String dynasty; //朝代
  String author; //作者
  List<String> content; //诗句内容
  List<String> translate; //诗句翻译

  PoetryOrigin.fromJSON(Map<String, dynamic> json) {
    title = optJSON(json, 'title');
    dynasty = optJSON(json, 'dynasty');
    author = optJSON(json, 'author');
    List list = optJSON(json, 'content');
    content = list?.map((item) => item.toString())?.toList();
    print('${content.length}');
    list = optJSON(json, 'translate');
    translate = list?.map((item) => item.toString())?.toList();
  }
}

class Poetry {
  String id;
  String content; //推荐的诗句
  int popularity; //流行度
  PoetryOrigin origin; //诗词源信息
  List<String> matchTags; //标签
  String recommendedReason; //推荐原因，暂无

  Poetry.fromJSON(Map<String, dynamic> json) {
    id = optJSON(json, 'id');
    content = optJSON(json, 'content');
    popularity = optJSON(json, 'popularity');
    origin = PoetryOrigin.fromJSON(optJSON(json, 'origin'));
    List list = optJSON(json, 'matchTags');
    matchTags = list?.map((m) => m.toString())?.toList();
    recommendedReason = optJSON(json, 'recommendedReason');
  }
}
