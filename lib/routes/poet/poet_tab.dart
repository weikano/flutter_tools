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
//            _CollectionsPage(),
//            _ThemesPage(),
//            _AuthorsPage(),
            _DynastiesPage(),
          ]),
        ),
      ),
    );
  }
}

const _padding = EdgeInsets.only(left: 12, bottom: 8, top: 8, right: 12);

class _ThemesPage extends NormalListPage<PoetTheme> {
  _ThemesPage()
      : super((_, data, prev) {
          return _Item(data.name);
        }, PoetDbHelper().allThemes());
}

class _CollectionsPage extends NormalListPage<Collection> {
  _CollectionsPage()
      : super((_, data, prev) {
          if (prev == null || data.kind_id != prev.kind_id) {
            return StickyHeader(
              header: Container(
                color: Colors.blue,
                child: Padding(
                  padding: _padding,
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      data.kindId,
                      style: sectionTextStyle,
                    ),
                  ),
                ),
              ),
              content: InkWell(
                child: _Item(data.name),
                onTap: () {
                  _jumpToCollectionQuotesPage(_, data);
                },
              ),
            );
          } else {
            return InkWell(
              child: _Item(data.name),
              onTap: () {
                _jumpToCollectionQuotesPage(_, data);
              },
            );
          }
        }, PoetDbHelper().allCollections());

  static _jumpToCollectionQuotesPage(BuildContext context, Collection data) {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => CollectionQuotesPage(data)));
  }
}

class _DynastiesPage extends NormalListPage<Dynasty> {
  _DynastiesPage()
      : super((_, data, prev) {
          return _Item(data.name);
        }, PoetDbHelper().allDynasties());
}

class _AuthorsPage extends NormalListPage<Author> {
  _AuthorsPage()
      : super((_, data, prev) {
          return _Item(data.name);
        }, PoetDbHelper().allAuthors());
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
