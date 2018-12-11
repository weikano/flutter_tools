import 'package:flutter_tools/tools/network.dart' as NETWORK;
import 'const.dart' as CONST;
import 'package:flutter_tools/basic.dart';

Future<ApiResponse<CONST.ZhihuNews>> getNews() async {
  try {
    Map<String, dynamic> json = await NETWORK.get(CONST.NEWS);
    return ApiResponse.ofSuccess(CONST.ZhihuNews.fromJSON(json));
  } on Exception catch (e) {
    return ApiResponse.ofError(e);
  }
}

Future<ApiResponse<CONST.ZhihuStory>> getStoryDetail(int id) async {
  try {
    Map<String, dynamic> json = await NETWORK.get('${CONST.CONTENT}/$id');
    return ApiResponse.ofSuccess(CONST.ZhihuStory.fromJSON(json));
  } on Exception catch (e) {
    return ApiResponse.ofError(e);
  }
}

Future<ApiResponse<CONST.ZhihuStoryExtra>> getStoryExtra(int id) async {
  try {
    Map<String, dynamic> json = await NETWORK.get('${CONST.EXTRA}/$id');
    return ApiResponse.ofSuccess(CONST.ZhihuStoryExtra.fromJSON(json));
  } on Exception catch (e) {
    return ApiResponse.ofError(e);
  }
}

@deprecated
Future<CONST.ZhihuNews> news() async {
  Map<String, dynamic> json = await NETWORK.get(CONST.NEWS);
  return CONST.ZhihuNews.fromJSON(json);
}

@deprecated
Future<CONST.ZhihuStory> content(int id) async {
  Map<String, dynamic> json = await NETWORK.get('${CONST.CONTENT}/$id');
  return CONST.ZhihuStory.fromJSON(json);
}

@deprecated
Future<CONST.ZhihuStoryExtra> extra(int id) async {
  Map<String, dynamic> json = await NETWORK.get('${CONST.EXTRA}/$id');
  return CONST.ZhihuStoryExtra.fromJSON(json);
}
