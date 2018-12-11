import 'package:flutter_tools/tools/network.dart' as NETWORK;
import 'const.dart' as CONST;

Future<CONST.News> news() async {
  Map<String, dynamic> json = await NETWORK.get(CONST.NEWS);
  return CONST.News.fromJSON(json);
}

Future<CONST.NewsContent> content(int id) async {
  Map<String, dynamic> json = await NETWORK.get('${CONST.CONTENT}/$id');
  return CONST.NewsContent.fromJSON(json);
}
