import 'dart:convert';
import 'dart:io';

import 'const.dart';

Future<WeatherReport> getReport() async {
  try {
    var _client = HttpClient();
    var _request = await _client.getUrl(Uri.parse(WEATHER));
    var _response = await _request.close();
    if (_response.statusCode == HttpStatus.ok) {
      var raw = await _response.transform(Utf8Decoder()).join();
      var tojson = json.decode(raw);
      List _weather = tojson['HeWeather6'];
      return WeatherReport.fromResponse(_weather[0]);
//      List _item = json.decode(raw)['HeWeather'];
//      return WeatherReport.fromResponse(_item[0]);
    }
  } catch (exception) {
    print(exception);
  }
  return WeatherReport.fail();
}
