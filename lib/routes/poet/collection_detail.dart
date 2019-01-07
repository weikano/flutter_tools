import 'package:flutter/material.dart';
import 'package:flutter_tools/routes/poet/const_fix.dart';
import 'package:flutter_tools/routes/poet/db_helper.dart';
import 'package:flutter_tools/routes/poet/styles.dart';
import 'package:flutter_tools/widgets/commons.dart';

///作品集中单项中收录的诗和摘录列表
class CollectionDetailPage extends StatelessWidget {
  final Collection item;

  CollectionDetailPage.factory(this.item);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text('分类'),
        ),
        body: _Body(item),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  final Collection item;
  _Body(this.item);
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<_Body> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: <Widget>[
          _buildThemeBrief(widget.item),
          Divider(
            height: 1,
            color: Colors.grey,
          ),
          TabBar(
            tabs: <Widget>[
              Tab(
                child: Text(
                  '作品',
                  style: TextStyle(color: Colors.black87),
                ),
              ),
              Tab(
                child: Text(
                  '摘录',
                  style: TextStyle(color: Colors.black87),
                ),
              ),
            ],
          ),
          Divider(
            height: 1,
          ),
          Expanded(
              child: TabBarView(children: <Widget>[
            _Works(widget.item),
            _Quotes(widget.item)
          ])),
        ],
      ),
    );
  }

  Widget _buildThemeBrief(Collection item) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(64)),
            child: Image.network(
              item.cover,
              fit: BoxFit.fill,
              width: 70,
              height: 70,
            ),
          ),
          SizedBox(
            width: 4,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  item.name,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  item.desc,
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

var _blackLarge = baseTextStyle.copyWith(
  color: Colors.black,
  fontSize: 16,
);

var _greyMedium = baseTextStyle.copyWith(
  color: Colors.grey,
  fontSize: 14,
);

var _divider = Divider(
  color: Colors.transparent,
  height: 4,
);

class _Works extends NormalListPage<CollectionWork> {
  final Collection collection;
  _Works(this.collection)
      : super((BuildContext ctx, data, prev) {
          return InkWell(
            onTap: () {
              //todo 跳转至作品详情
              print(data);
            },
            child: Padding(
              padding: padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: Text(
                        data.work_title,
                        style: _blackLarge,
                      )),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        "[${data.work_dynasty}] ${data.work_author}",
                        style: _greyMedium,
                      ),
                    ],
                  ),
                  _divider,
                  Text(
                    data.work_content,
                    style: _greyMedium,
                  ),
                ],
              ),
            ),
          );
        }, PoetDbHelper().allCollectionItemsById(collection),
            dividerWithPadding: true);
}

class _Quotes extends NormalListPage<CollectionQuote> {
  final Collection collection;
  _Quotes(this.collection)
      : super((BuildContext context, data, prev) {
          return InkWell(
            onTap: () {
              //todo 跳转至摘录详情
              print(data);
            },
            child: Padding(
              padding: padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    data.quote,
                    style: _blackLarge,
                  ),
                  _divider,
                  Text(
                    "${data.quote_author} 《${data.quote_work}》",
                    style: _greyMedium,
                  ),
                ],
              ),
            ),
          );
        }, PoetDbHelper().allQuotesByCollection(collection),
            dividerWithPadding: true);
}
