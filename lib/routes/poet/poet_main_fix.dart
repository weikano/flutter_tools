import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PoetMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        home: Scaffold(
          body: _PoetMainPageImpl(),
        ),
      ),
    );
  }
}

class _PoetMainPageImpl extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PoetMainPageImplState();
  }
}

class _TabItem extends StatelessWidget {
  final String label;

  _TabItem(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(label);
  }
}

class _PoetMainPageImplState extends State<_PoetMainPageImpl> {
  int _tabIndex = 0;

  Map<int, Widget> _buildTabs() {
    return {
      0: _TabItem('分类'),
      1: _TabItem('作品'),
      2: _TabItem('作者'),
    };
  }

  void onTabChanged(int value) {}

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CupertinoSegmentedControl<int>(
          children: _buildTabs(),
          onValueChanged: onTabChanged,
          groupValue: _tabIndex,
        ),
        Expanded(child: TabBarView(children: null)),
      ],
    );
  }
}
