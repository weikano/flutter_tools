import 'package:flutter/material.dart';
import 'package:flutter_tools/routes/poet/poet_tab.dart';

class PoetMainPage extends StatefulWidget {
  static var routeName = '/poet';
  static var title = '诗词赏析';

  @override
  State<StatefulWidget> createState() {
    return _PoetMainState();
  }
}

class _PoetMainState extends State<PoetMainPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PoetCategoryPage(),
    );
  }
}
