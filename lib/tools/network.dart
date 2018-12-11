import 'dart:convert';
import 'dart:io';

Future<dynamic> get(String url) async {
  var client = HttpClient();
  print('start get request for # $url');
  var request = await client.getUrl(Uri.parse(url));
  var response = await request.close();
  print("receive response");
  if (response.statusCode == HttpStatus.ok) {
    var raw = await response.transform(Utf8Decoder()).join();
    print('receive response with $raw');
    return json.decode(raw);
  } else {
    print('get request with statusCode # ${response.statusCode}');
    throw Exception('HTTP status code is ${response.statusCode}');
  }
}
