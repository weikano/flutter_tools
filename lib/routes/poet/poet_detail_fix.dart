import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_tools/basic.dart';
import 'package:flutter_tools/routes/poet/const_fix.dart';
import 'package:flutter_tools/routes/poet/db_helper.dart';
import 'package:flutter_tools/routes/poet/styles.dart';
import 'package:flutter_tools/widgets/commons.dart';

///诗词详情显示
class PoetDetailPageFix extends StatelessWidget {
  final _From from;
  final dynamic data;

  PoetDetailPageFix.fromCollectionQuote(this.data)
      : from = _From.fromCollectionQuote;
  PoetDetailPageFix.fromCollectionWork(this.data)
      : from = _From.fromCollectionWork;
  PoetDetailPageFix.fromWork(this.data) : from = _From.fromWork;

  @override
  Widget build(BuildContext context) {
    var author = '';
    var title = '';
    _Body body;
    if (from == _From.fromCollectionQuote) {
      author = (data as CollectionQuote).quote_author;
      title = (data as CollectionQuote).quote_work;
      body = _Body.fromCollectionQuote(data);
    } else if (from == _From.fromCollectionWork) {
      author = (data as CollectionWork).work_author;
      title = (data as CollectionWork).work_title;
      body = _Body.fromCollectionWork(data);
    } else {
      author = (data as Work).author;
      title = (data as Work).title;
      body = _Body.fromWork(data);
    }
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            '$title-$author',
            style: Theme.of(context)
                .textTheme
                .subtitle
                .copyWith(fontSize: 18, color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: body,
        ),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  final dynamic data;
  final _From from;

  _Body.fromCollectionQuote(this.data) : from = _From.fromCollectionQuote;
  _Body.fromCollectionWork(this.data) : from = _From.fromCollectionWork;
  _Body.fromWork(this.data) : from = _From.fromWork;

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<_Body> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (BuildContext _, AsyncSnapshot<ApiResponse<Work>> data) {
        if (data.hasError) {
          return ReloadButton();
        } else if (data.hasData) {
          var d = data.data;
          if (d.fail()) {
            return ReloadButton();
          } else if (d.success()) {
            return _WorkWidget(d.response);
          }
        } else {
          return LoadingIndicator();
        }
      },
      future: _futureApi(),
      initialData: ApiResponse<Work>.ofLoading(),
    );
  }

  Future<ApiResponse<Work>> _futureApi() {
    if (widget.from == _From.fromCollectionQuote) {
      return PoetDbHelper().workDetailByQuoteId(widget.data);
    } else if (widget.from == _From.fromCollectionWork) {
      return PoetDbHelper().workDetailById(widget.data.work_id);
    } else {
      return Future(() {
        return ApiResponse.ofSuccess(widget.data);
      });
    }
  }
}

class _WorkWidget extends StatefulWidget {
  final Work data;

  _WorkWidget(this.data);

  @override
  State<StatefulWidget> createState() {
    return _WorkWidgetState();
  }
}

class _WorkWidgetState extends State<_WorkWidget> {
  Map<int, Widget> _children;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _children = {
      0: Text('详情'),
      1: Text('简介'),
      2: Text('注释'),
      3: Text('翻译'),
      4: Text('赏析'),
    };
    _content = [
      _WorkContentWidget(widget.data),
      _WorkIntroWidget(widget.data),
      _WorkAnnotationWidget(widget.data),
      _WorkTranslationWidget(widget.data),
      _WorkAppreciationWidget(widget.data)
    ];
  }

  List<Widget> _content = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CupertinoSegmentedControl<int>(
          children: _children.map((index, Widget item) => MapEntry(
              index,
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                child: item,
              ))),
          onValueChanged: (int value) {
            setState(() {
              _current = value;
            });
          },
          groupValue: _current,
        ),
        Divider(
          color: Colors.transparent,
          height: 16,
        ),
        Expanded(child: SingleChildScrollView(child: _content[_current]))
      ],
    );
  }
}

abstract class _WorkBasicWidget extends StatelessWidget {
  final Work data;
  _WorkBasicWidget(this.data);
  @override
  Widget build(BuildContext context) {
    if (contentIsEmpty()) {
      return EmptyWidget.factory();
    }
    return buildContentWidget(context);
  }

  bool contentIsEmpty();

  Widget buildContentWidget(BuildContext context);
}

///展示诗词内容
class _WorkContentWidget extends _WorkBasicWidget {
  _WorkContentWidget(Work data) : super(data);

  @override
  Widget buildContentWidget(BuildContext context) {
    return Text(
      data.content,
      style: baseTextStyle.copyWith(
          fontSize: Theme.of(context).textTheme.title.fontSize,
          color: Colors.black),
    );
  }

  @override
  bool contentIsEmpty() {
    return data.content.isEmpty;
  }
}

class _WorkIntroWidget extends _WorkBasicWidget {
  _WorkIntroWidget(Work data) : super(data);

  @override
  Widget buildContentWidget(BuildContext context) {
    return Text(
      data.intro,
      style: Theme.of(context).textTheme.body1.copyWith(color: Colors.black87),
    );
  }

  @override
  bool contentIsEmpty() {
    return data.intro.isEmpty;
  }
}

class _WorkAnnotationWidget extends _WorkBasicWidget {
  _WorkAnnotationWidget(Work data) : super(data);

  @override
  Widget buildContentWidget(BuildContext context) {
    return Text(
      data.annotation,
      style: Theme.of(context).textTheme.body1.copyWith(color: Colors.black87),
    );
  }

  @override
  bool contentIsEmpty() {
    return data.annotation.isEmpty;
  }
}

class _WorkTranslationWidget extends _WorkBasicWidget {
  _WorkTranslationWidget(Work data) : super(data);

  @override
  Widget buildContentWidget(BuildContext context) {
    return Text(
      data.translation,
      style: Theme.of(context).textTheme.body1.copyWith(color: Colors.black87),
    );
  }

  @override
  bool contentIsEmpty() {
    return data.translation.isEmpty;
  }
}

class _WorkAppreciationWidget extends _WorkBasicWidget {
  _WorkAppreciationWidget(Work data) : super(data);

  @override
  Widget buildContentWidget(BuildContext context) {
    return Text(
      data.appreciation,
      style: Theme.of(context).textTheme.body1.copyWith(color: Colors.black87),
    );
  }

  @override
  bool contentIsEmpty() {
    return data.appreciation.isEmpty;
  }
}

///从哪点进来
enum _From { fromCollectionWork, fromCollectionQuote, fromWork }
