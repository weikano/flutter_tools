import 'package:flutter/material.dart';
import 'package:flutter_tools/routes/poet/const_fix.dart';
import 'package:flutter_tools/routes/poet/db_helper.dart';
import 'package:flutter_tools/routes/poet/styles.dart';
import 'package:flutter_tools/widgets/commons.dart';

class AuthorWorksByKind extends StatelessWidget {
  final _tabs = ['诗', '词', '曲', '赋', '文'];
  final _ids = ['shi', 'ci', 'qu', 'fu', 'wen'];
  final Author author;
  final String kind;
  final String kindId;
  AuthorWorksByKind.factory(this.author, this.kindId, this.kind);
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: _ids.indexOf(kindId),
      length: 5,
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text("${author.name}作品集"),
            leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                }),
            centerTitle: true,
            bottom: TabBar(
                tabs: _tabs
                    .map((it) => Tab(
                          child: Text(it),
                        ))
                    .toList()),
          ),
          body: TabBarView(
              children: _ids.map((it) => _Body(author, it)).toList()),
        ),
      ),
    );
  }
}

var _styleTitle = baseTextStyle.copyWith(
  color: Colors.black,
  fontSize: 18,
);

var _styleContent = _styleTitle.copyWith(
  color: Colors.black45,
  fontSize: 14,
);

class _Body extends NormalListPage<Work> {
  final Author author;
  final String kindId;
  _Body(this.author, this.kindId)
      : super((_, data, prev) {
          String content = data.content;
          content = content.substring(0, content.indexOf("。"));
          return InkWell(
            onTap: () {
              //todo 跳转到作品详情
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    data.title,
                    style: _styleTitle,
                  ),
                  Divider(
                    height: 4,
                    color: Colors.transparent,
                  ),
                  Text(
                    content,
                    style: _styleContent,
                  ),
                ],
              ),
            ),
          );
        }, DbHelper().worksByAuthorAndKind(author, kindId),
            dividerWithPadding: true);
}
