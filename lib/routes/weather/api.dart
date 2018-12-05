import 'dart:convert';
import 'dart:io';

import 'const.dart';

Future<WeatherReport> getReport() async {
  try {
    var _client = HttpClient();
    var _request = await _client.getUrl(Uri.parse(WEATHER));
    var _response = await _request.close();
    if (_response.statusCode == HttpStatus.ok) {
      var _json = await _response.transform(Utf8Decoder()).join();
      return WeatherReport.fromResponse(json.decode(_json)['HeWeather6']);
    }
  } catch (exception) {
    print(exception);
  }
  return WeatherReport.fail();
}
