import 'package:flutter_tools/tools/network.dart' as NETWORK;
import 'const.dart' as CONST;

Future<CONST.ZhihuNews> news() async {
  Map<String, dynamic> json = await NETWORK.get(CONST.NEWS);
  return CONST.ZhihuNews.fromJSON(json);
}

Future<CONST.ZhihuStory> content(int id) async {
  Map<String, dynamic> json = await NETWORK.get('${CONST.CONTENT}/$id');
  return CONST.ZhihuStory.fromJSON(json);
}

Future<CONST.ZhihuStoryExtra> extra(int id) async {
  Map<String, dynamic> json = await NETWORK.get('${CONST.EXTRA}/$id');
  return CONST.ZhihuStoryExtra.fromJSON(json);
}
