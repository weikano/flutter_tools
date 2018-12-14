import 'dart:convert';
import 'dart:io';

Future<dynamic> get(String url) async {
  var client = HttpClient();
  print('start get request for # $url');
  var request = await client.getUrl(Uri.parse(url));
  request.followRedirects = true;
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

Future<dynamic> post(String url, [Map<String, dynamic> headers]) async {
  var client = HttpClient();
  print('start get request for # $url');
  var request = await client.postUrl(Uri.parse(url));
  for (var key in headers.keys) {
    request.headers.add(key, headers[key]);
  }
  request.followRedirects = true;
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
