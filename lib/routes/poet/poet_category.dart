import 'package:flutter/material.dart';
import 'package:flutter_tools/routes/poet/const_fix.dart';
import 'package:flutter_tools/routes/poet/db_helper.dart';
import 'package:flutter_tools/routes/poet/poet_detail.dart';
import 'package:flutter_tools/routes/poet/styles.dart';
import 'package:flutter_tools/widgets/commons.dart';

class CollectionQuotesPage extends StatelessWidget {
  final Collection data;

  CollectionQuotesPage(this.data);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            data.name,
            style: _titleStyle.copyWith(color: Colors.white),
          ),
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: _CollectionQuotesPage(data),
      ),
    );
  }
}

var _titleStyle = baseTextStyle.copyWith(fontSize: 18, color: Colors.indigo);
var _authorStyle =
    baseTextStyle.copyWith(fontSize: 14, color: Colors.indigoAccent);
var _contentStyle = baseTextStyle.copyWith(fontSize: 16, color: Colors.grey);

class _CollectionQuotesPage extends NormalListPage<CollectionQuote> {
  final Collection data;

  static _jumpToWorkDetail(BuildContext context, CollectionQuote data) {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => WorkFromCollectionQuotePage(data)));
  }

  _CollectionQuotesPage(this.data)
      : super(
            (_, data, prev) {
              return Padding(
                padding: padding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            data.quote_work,
                            style: _titleStyle,
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          data.quote_author,
                          style: _authorStyle,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      data.quote,
                      style: _contentStyle,
                    ),
                  ],
                ),
              );
            },
            PoetDbHelper().allQuotesByCollection(data),
            onItemClick: (BuildContext _, dynamic data) {
              _jumpToWorkDetail(_, data);
            });
}
