import 'package:flutter/material.dart';
import 'package:flutter_tools/themes.dart';

import 'data/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Map<String, WidgetBuilder> _buildRoutes() {
    return Map<String, WidgetBuilder>.fromIterable(
      allRoutes,
      key: (dynamic demo) => '${demo.routeName}',
      value: (dynamic demo) => demo.builder,
    );
  }

  @override
  Widget build(BuildContext context) {
    final int columnCount = 3;
//    final int columnCount =
//        MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 3;
    return MaterialApp(
      theme: kLightTheme,
      title: 'tools',
      home: _Home(columnCount),
      routes: _buildRoutes(),
    );
  }
}

class _Home extends StatelessWidget {
  _Home(this.columnCount);
  final int columnCount;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TOOLBOX'),
      ),
      body: GridView.count(
        crossAxisCount: columnCount,
        children: allRoutes.map((RouteData data) {
          return _RouteItem(
            data: data,
            onTap: () {
              Navigator.pushNamed(context, data.routeName);
            },
          );
        }).toList(),
      ),
    );
  }
}

const Color _defaultColor = Color(0xFF003D75);

class _RouteItem extends StatelessWidget {
  _RouteItem({this.onTap, this.data});
  final VoidCallback onTap;
  final RouteData data;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    return RawMaterialButton(
      padding: EdgeInsets.zero,
      splashColor: theme.primaryColor.withOpacity(0.12),
      highlightColor: Colors.transparent,
      onPressed: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            data.iconUrl,
            width: 60.0,
            height: 60.0,
          ),
          const SizedBox(
            height: 4.0,
          ),
          Container(
            height: 24.0,
            alignment: Alignment.center,
            child: Text(
              data.title,
              textAlign: TextAlign.center,
              style: theme.textTheme.subhead.copyWith(
                color: isDark ? Colors.white : _defaultColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
