import 'package:flutter/material.dart';
import 'package:flutter_tools/themes.dart';
import 'api.dart';
import 'const.dart';
import 'package:flutter_tools/basic.dart';

class GankIOPage extends StatefulWidget {
  static var routeName = '/gankio';
  static var title = 'Gank';

  @override
  State<StatefulWidget> createState() {
    return _GankIOState();
  }
}

class _GankIOState extends StateWithFuture<GankIOPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
        var tab;
        Widget child = Center(
          child: CircularProgressIndicator(),
        );
        if (snapshot.hasError) {
          child = Center(
            child: RaisedButton.icon(
              onPressed: () {
                print('click to refresh');
              },
              icon: Icon(Icons.error),
              label: Text('Reload'),
            ),
          );
        } else if (snapshot.hasData) {
          tab = TabBar(
            tabs: snapshot.data.map((m) => Tab(child: Text(m.name))).toList(),
            isScrollable: true,
          );
          child = TabBarView(
              children: snapshot.data
                  .map((m) => _buildCategoryDetailList(m))
                  .toList());
        }

        return DefaultTabController(
          length: snapshot.data.length,
          child: MaterialApp(
            theme: kDarkTheme,
            home: Scaffold(
              appBar: AppBar(
                title: Text(GankIOPage.title),
                centerTitle: true,
                bottom: tab,
              ),
              body: child,
            ),
          ),
        );
      },
      initialData: kCategories,
      future: categoriesDebug(),
    );
  }

  Widget _buildCategoryDetailList(Category category) {
    return Center(
      child: ListTile(
        title: Text(category.name),
        subtitle: Text(category.code),
      ),
    );
  }
}
