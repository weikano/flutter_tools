import 'package:flutter_tools/tools/network.dart';
import 'package:flutter_tools/converter/json_converter.dart';
import 'package:flutter_tools/basic.dart';
import 'const.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<ApiResponse<Poetry>> poetry() async {
  try {
    var sp = await SharedPreferences.getInstance();
    var token = sp.getString(TOKEN_KEY);
    if (token == null || token.isEmpty) {
      Map<String, dynamic> tokenJson = await get(TOKEN);
      if (_validResponse(tokenJson)) {
        token = optJSON(tokenJson, 'data');
        await sp.setString(TOKEN_KEY, token);
      }
    }
    Map<String, dynamic> json = await post(ONE, {'X-User-Token': token});
    if (_validResponse(json)) {
      return ApiResponse.ofSuccess(Poetry.fromJSON(optJSON(json, 'data')));
    } else {
      return ApiResponse.ofError(Exception(optJSON(json, 'errMsg')));
    }
  } on Exception catch (e) {
    return ApiResponse.ofError(e);
  }
}

bool _validResponse(Map<String, dynamic> json) {
  return json != null && optJSON(json, 'status') == 'success';
}
