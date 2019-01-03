import 'package:url_launcher/url_launcher.dart';

void openWebView(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  }
  print('无法打开链接');
}
