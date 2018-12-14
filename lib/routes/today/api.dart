import 'const.dart';
import 'package:flutter_tools/converter/json_converter.dart';
import 'package:flutter_tools/tools/network.dart';
import 'package:flutter_tools/basic.dart';

Future<ApiResponse<List<EventBrief>>> today([DateTime now]) async {
  if (now == null) {
    now = DateTime.now();
  }
  String date = '${now.month}/${now.day}';
  var url = '$TODAY&date=$date';
  try {
    Map<String, dynamic> result = await get(url);
    if (_validResponse(result)) {
      List list = optJSON(result, 'data');
      List<EventBrief> briefs = <EventBrief>[];
      briefs = list?.map((item) => EventBrief.fromJSON(item))?.toList();
      return ApiResponse.ofSuccess(briefs);
    } else {
      return ApiResponse.ofError(Exception(optJSON(result, 'reason')));
    }
  } on Exception catch (e) {
    return ApiResponse.ofError(e);
  }
}

Future<ApiResponse<EventDetail>> detail(String eid) async {
  var url = '$DETAIL&date=$eid';
  try {
    Map<String, dynamic> result = await get(url);
    if (_validResponse(result)) {
      return ApiResponse.ofSuccess(
          EventDetail.fromJSON(optJSON(result, 'data')));
    } else {
      return ApiResponse.ofError(Exception(optJSON(result, 'reason')));
    }
  } on Exception catch (e) {
    return ApiResponse.ofError(e);
  }
}

bool _validResponse(Map<String, dynamic> json) {
  return optJSON(json, 'error_code') == 0;
}
