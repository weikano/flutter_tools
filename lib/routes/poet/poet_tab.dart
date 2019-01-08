import 'package:flutter/material.dart';
import 'package:flutter_tools/routes/poet/author_tab.dart';
import 'package:flutter_tools/routes/poet/const_fix.dart';
import 'package:flutter_tools/routes/poet/db_helper.dart';
import 'package:flutter_tools/routes/poet/collection_tab.dart';
import 'package:flutter_tools/routes/poet/poet_category.dart';
import 'package:flutter_tools/routes/poet/styles.dart';
import 'package:flutter_tools/widgets/commons.dart';
import 'package:sticky_headers/sticky_headers.dart';

class PoetCategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: TabBar(
            tabs: ['作品集', '作者', '作品']
                .map((m) => Tab(
                      child: Text(
                        m,
                        style: TextStyle(color: Colors.black),
                      ),
                    ))
                .toList(),
            isScrollable: true,
          ),
          body: TabBarView(children: [
            CollectionTab(),
            AuthorTab(),
            _DynastiesPage(),
          ]),
        ),
      ),
    );
  }
}

const _padding = EdgeInsets.only(left: 12, bottom: 8, top: 8, right: 12);

class _DynastiesPage extends NormalListPage<Dynasty> {
  _DynastiesPage()
      : super((_, data, prev) {
          return _Item(data.name);
        }, PoetDbHelper().allDynasties());
}

class _Item extends StatelessWidget {
  final String data;

  _Item(this.data);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _padding,
      child: Text(
        data,
        style: itemTextStyle,
      ),
    );
  }
}
