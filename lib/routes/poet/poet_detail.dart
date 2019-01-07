import 'package:flutter/material.dart';
import 'package:flutter_tools/basic.dart';
import 'package:flutter_tools/routes/poet/const_fix.dart';
import 'package:flutter_tools/routes/poet/db_helper.dart';
import 'package:flutter_tools/routes/poet/styles.dart';
import 'package:flutter_tools/utils.dart';
import 'package:flutter_tools/widgets/commons.dart';
import 'package:url_launcher/url_launcher.dart';

class WorkFromCollectionQuotePage extends StatefulWidget {
  final CollectionQuote quote;

  WorkFromCollectionQuotePage(this.quote);

  @override
  State<StatefulWidget> createState() {
    return _WorkFromCollectionQuotePageState();
  }
}

class _TextOptionsMenu extends StatelessWidget {
  final String data;
  final VoidCallback onTap;
  final String message;

  _TextOptionsMenu({this.data, this.onTap, this.message});

  @override
  Widget build(BuildContext context) {
    var size = kToolbarHeight / 5 * 3;
    return SizedBox(
      height: size,
      width: size,
      child: Tooltip(
        message: message,
        child: InkWell(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(size)),
                border: Border.all(color: Colors.grey)),
            child: Center(
              child: Text(data),
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}

class _WorkFromCollectionQuotePageState
    extends State<WorkFromCollectionQuotePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (_, AsyncSnapshot<ApiResponse<Work>> data) {
        Widget content;
        if (data.hasError) {
          content = Center(
            child: ReloadButton(),
          );
        } else if (data.hasData) {
          var d = data.data;
          if (d.fail()) {
            content = Center(
              child: ReloadButton(),
            );
          } else if (d.success()) {
            content = _WorkContent(d.response);
          }
        } else {
          content = LoadingIndicator();
        }
        return MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
            body: content,
          ),
        );
      },
      future: PoetDbHelper().workDetailByQuoteId(widget.quote),
      initialData: ApiResponse<Work>.ofLoading(),
    );
  }
}

TextStyle _styleTitle = baseTextStyle.copyWith(
  fontSize: 26,
  fontWeight: FontWeight.w500,
);

TextStyle _styleAuthor = baseTextStyle.copyWith(
  color: Colors.blue,
  fontSize: 22,
  fontStyle: FontStyle.italic,
);

TextStyle _styleContent = baseTextStyle.copyWith(
  color: Colors.black87,
  fontSize: 20,
);

var _padding = const SizedBox(
  height: 12,
);

///作品内容展示(标题/作者/内容)
class _WorkContent extends StatelessWidget {
  final Work work;

  _WorkContent(this.work);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(children: <Widget>[
        Padding(
          padding: padding.copyWith(
              top: kToolbarHeight, bottom: kToolbarHeight + 24),
          child: Scrollbar(
            child: SingleChildScrollView(
              controller: ScrollController(),
              child: Column(
                children: _buildContent(),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: ButtonBar(
              alignment: MainAxisAlignment.center,
              children: _buildBottomActions()),
        ),
      ]),
    );
  }

  List<Widget> _buildBottomActions() {
    List<Widget> actions = <Widget>[];
    if (work.intro != null) {
      actions.add(_TextOptionsMenu(
        data: '介',
        onTap: _intro,
        message: "介绍",
      ));
    }
    if (work.annotation != null) {
      actions.add(_TextOptionsMenu(
        data: '注',
        onTap: _annotation,
        message: "注解",
      ));
    }
    if (work.translation != null) {
      actions.add(_TextOptionsMenu(
        data: '译',
        onTap: _translation,
        message: "翻译",
      ));
    }
    if (work.appreciation != null) {
      actions.add(_TextOptionsMenu(
        data: '赏',
        onTap: _appreciation,
        message: "赏析",
      ));
    }
    if (work.wiki != null) {
      actions.add(_TextOptionsMenu(
        data: '网',
        onTap: () {
          openWebView(work.wiki);
        },
        message: "百度链接",
      ));
    }
    return actions;
  }

  List<Widget> _buildContent() {
    var content = <Widget>[
      _padding,
    ];
    content.add(Text(
      work.title,
      style: _styleTitle,
    ));
    content.add(_padding);
    content.add(Text(
      '[${work.dynasty}]${work.author}',
      style: _styleAuthor,
    ));
    content.add(_padding);
    content.add(Text(
      work.content,
      style: _styleContent,
    ));
//    work.content.split("。").forEach((item) {
//      content.add(Text(
//        item,
//        style: _styleContent,
//      ));
//    });

    return content;
  }

  void _intro() {}

  void _annotation() {}

  void _translation() {}

  void _appreciation() {}

//  void _baidu() async {
//    if (await canLaunch(work.wiki)) {
//      await launch(work.wiki);
//    }
//  }
}
