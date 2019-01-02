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
//    return MaterialApp(
//      home: Scaffold(
//        bottomNavigationBar: BottomNavigationBar(currentIndex: 0, items: [
//          BottomNavigationBarItem(
//            icon: Icon(Icons.home),
//            title: Text('遇见'),
//          ),
//          BottomNavigationBarItem(
//            icon: Icon(Icons.category),
//            title: Text('分类'),
//          ),
//          BottomNavigationBarItem(
//            icon: Icon(Icons.search),
//            title: Text('搜索'),
//          ),
//        ]),
//      ),
//    );
  }
}
