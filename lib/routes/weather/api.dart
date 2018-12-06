import 'dart:convert';
import 'dart:io';

import 'const.dart';

Future<WeatherReport> getReport() async {
  try {
    var _client = HttpClient();
    var _request = await _client.getUrl(Uri.parse(WEATHER));
    print('start request..');
    var _response = await _request.close();
    print('receive response..');
    if (_response.statusCode == HttpStatus.ok) {
      print('response success..');
      var raw = await _response.transform(Utf8Decoder()).join();
      print('raw json :$raw');
      var tojson = json.decode(raw);
      List _weather = tojson['HeWeather6'];
      print('decoded heweather6:$_weather');
      return WeatherReport.ofSuccess(_weather[0]);
    }
  } catch (exception) {
    print(exception);
  }
  return WeatherReport.ofFail();
}

Future<WeatherReport> getReportTest() async {
  var raw =
      '{"HeWeather6":[{"basic":{"cid":"CN101280601","location":"深圳","parent_city":"深圳","admin_area":"广东","cnty":"中国","lat":"22.54700089","lon":"114.08594513","tz":"+8.00"},"update":{"loc":"2018-12-06 08:46","utc":"2018-12-06 00:46"},"status":"ok","now":{"cloud":"25","cond_code":"104","cond_txt":"阴","fl":"25","hum":"82","pcpn":"0.0","pres":"1015","tmp":"23","vis":"22","wind_deg":"49","wind_dir":"东北风","wind_sc":"1","wind_spd":"3"},"daily_forecast":[{"cond_code_d":"104","cond_code_n":"104","cond_txt_d":"阴","cond_txt_n":"阴","date":"2018-12-06","hum":"82","mr":"05:35","ms":"17:02","pcpn":"0.0","pop":"25","pres":"1016","sr":"06:50","ss":"17:39","tmp_max":"26","tmp_min":"16","uv_index":"1","vis":"16","wind_deg":"-1","wind_dir":"无持续风向","wind_sc":"1-2","wind_spd":"9"},{"cond_code_d":"300","cond_code_n":"104","cond_txt_d":"阵雨","cond_txt_n":"阴","date":"2018-12-07","hum":"67","mr":"06:30","ms":"17:47","pcpn":"2.0","pop":"59","pres":"1019","sr":"06:51","ss":"17:39","tmp_max":"20","tmp_min":"13","uv_index":"0","vis":"19","wind_deg":"-1","wind_dir":"无持续风向","wind_sc":"1-2","wind_spd":"9"},{"cond_code_d":"104","cond_code_n":"104","cond_txt_d":"阴","cond_txt_n":"阴","date":"2018-12-08","hum":"67","mr":"07:25","ms":"18:34","pcpn":"1.0","pop":"55","pres":"1021","sr":"06:52","ss":"17:39","tmp_max":"18","tmp_min":"11","uv_index":"1","vis":"19","wind_deg":"-1","wind_dir":"无持续风向","wind_sc":"1-2","wind_spd":"7"}],"lifestyle":[{"type":"comf","brf":"较舒适","txt":"白天有雨，从而使空气湿度加大，会使人们感觉有点儿闷热，但早晚的天气很凉爽、舒适。"},{"type":"drsg","brf":"舒适","txt":"建议着长袖T恤、衬衫加单裤等服装。年老体弱者宜着针织长袖衬衫、马甲和长裤。"},{"type":"flu","brf":"易发","txt":"昼夜温差大，且空气湿度较大，易发生感冒，请注意适当增减衣服，加强自我防护避免感冒。"},{"type":"sport","brf":"较不宜","txt":"有降水，推荐您在室内进行健身休闲运动；若坚持户外运动，须注意携带雨具并注意避雨防滑。"},{"type":"trav","brf":"适宜","txt":"温度适宜，又有较弱降水和微风作伴，会给您的旅行带来意想不到的景象，适宜旅游，可不要错过机会呦！"},{"type":"uv","brf":"最弱","txt":"属弱紫外线辐射天气，无需特别防护。若长期在户外，建议涂擦SPF在8-12之间的防晒护肤品。"},{"type":"cw","brf":"不宜","txt":"不宜洗车，未来24小时内有雨，如果在此期间洗车，雨水和路上的泥水可能会再次弄脏您的爱车。"},{"type":"air","brf":"较差","txt":"气象条件较不利于空气污染物稀释、扩散和清除，请适当减少室外活动时间。"}]}]}';
  await Future.delayed(Duration(milliseconds: 500));
  var toJson = json.decode(raw);
  List weather = toJson['HeWeather6'];
  return WeatherReport.ofSuccess(weather[0]);
}
