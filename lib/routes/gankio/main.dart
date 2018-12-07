import 'package:flutter/material.dart';
import 'package:flutter_tools/routes/gankio/gank_by_categories.dart';
import 'package:flutter_tools/routes/gankio/gank_by_date.dart';
import 'package:flutter_tools/routes/gankio/gank_by_random.dart';
import 'package:flutter_tools/themes.dart';
import 'package:flutter_tools/widgets/bottom_navigation.dart';

class GankMainPage extends StatefulWidget {
  static var routeName = '/gankio';
  static var title = 'Gank';

  @override
  State<StatefulWidget> createState() {
    return _GankMainState();
  }
}

class _GankMainState extends State<GankMainPage> with TickerProviderStateMixin {
  int _index = 0;
  BottomNavigationBarType _type = BottomNavigationBarType.shifting;
  List<NavigationIconView> _navigationViews;
  List<Widget> _pages;
  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      GankCategoryPage(),
      GankRandomPage(),
      GankDatePage(),
      GankDatePage(),
    ];
    _navigationViews = <NavigationIconView>[
      NavigationIconView(
        icon: const Icon(Icons.category),
        title: '分类',
        color: Colors.deepPurple,
        vsync: this,
      ),
      NavigationIconView(
        icon: const Icon(Icons.apps),
        title: '随机',
        color: Colors.deepOrange,
        vsync: this,
      ),
      NavigationIconView(
        icon: const Icon(Icons.calendar_today),
        title: '按日期',
        color: Colors.teal,
        vsync: this,
      ),
      NavigationIconView(
        icon: const Icon(Icons.favorite),
        title: '阅读记录',
        color: Colors.pink,
        vsync: this,
      ),
    ];
    _navigationViews[_index].controller.value = 1.0;
  }

  @override
  void dispose() {
    for (NavigationIconView item in _navigationViews) {
      item.controller.dispose();
    }
    super.dispose();
  }

  Widget _buildTransitionsStack() {
    return _pages[_index];
  }

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBar botNavBar = BottomNavigationBar(
      items: _navigationViews
          .map<BottomNavigationBarItem>(
              (NavigationIconView navigationView) => navigationView.item)
          .toList(),
      currentIndex: _index,
      type: _type,
      onTap: (int index) {
        setState(() {
          _navigationViews[_index].controller.reverse();
          _index = index;
          _navigationViews[_index].controller.forward();
        });
      },
    );
    return MaterialApp(
      theme: kLightTheme,
      home: Scaffold(
        body: _buildTransitionsStack(),
        bottomNavigationBar: botNavBar,
      ),
    );
  }
}
