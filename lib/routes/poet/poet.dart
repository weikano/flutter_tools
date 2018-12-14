import 'package:flutter/material.dart';
import 'package:flutter_tools/basic.dart';
import 'package:flutter_tools/widgets/commons.dart';
import 'const.dart';
import 'api.dart';

class DailyPoetPage extends StatefulWidget {
  static var routeName = '/poet';
  static var title = '今日诗词';

  @override
  State<StatefulWidget> createState() {
    return _DailyPoetState();
  }
}

TextStyle _font = TextStyle(
  fontFamily: 'poet',
  color: Colors.black,
);

TextStyle _styleTitle = _font.copyWith(
  fontSize: 26,
  fontWeight: FontWeight.w500,
);

TextStyle _styleAuthor = _font.copyWith(
  color: Colors.blue,
  fontSize: 22,
  fontStyle: FontStyle.italic,
);

TextStyle _styleContent = _font.copyWith(
  color: Colors.black87,
  fontSize: 20,
);

TextStyle _styleContentSpecial = _styleContent.copyWith(
  color: Colors.cyan,
);

ScrollController _controller = ScrollController();
Widget _padding = SizedBox(
  height: 12,
);

Widget _padding2x = SizedBox(
  height: 24,
);

class _DailyPoetState extends State<DailyPoetPage> {
  @override
  Widget build(BuildContext _context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(DailyPoetPage.title),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print('refresh');
          },
          backgroundColor: Colors.orange,
          child: Icon(
            Icons.refresh,
          ),
          tooltip: '切换',
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: _bottomAppBar(() {
          //todo 显示解析
        }),
        body: FutureBuilder(
          builder:
              (BuildContext _, AsyncSnapshot<ApiResponse<Poetry>> snapshot) {
            Widget content = Center(
              child: CircularProgressIndicator(),
            );
            if (snapshot.hasData) {
              var data = snapshot.data;
              if (data.success()) {
                content = _buildPoet(data.response);
              } else if (data.fail()) {
                Center(
                  child: content = ReloadButton(
                    onPressed: () {
                      print('reloead');
                    },
                  ),
                );
              }
            }
            return content;
          },
          future: poetry(),
          initialData: ApiResponse<Poetry>.ofLoading(),
        ),
      ),
    );
  }

  Widget _buildPoet(Poetry poet) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Center(
        child: Scrollbar(
          child: SingleChildScrollView(
            controller: _controller,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildPoetInner(poet),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPoetInner(Poetry poet) {
    List<Widget> body = <Widget>[];
    body.add(_padding);
    //标题
    body.add(Text(
      poet.origin.title,
      style: _styleTitle,
    ));
    body.add(_padding);
    //作者
    body.add(Text(
      '[${poet.origin.dynasty}] ${poet.origin.author}',
      style: _styleAuthor,
    ));
    body.add(_padding);
    body.addAll(poet.origin.content.map((line) {
      return Text(
        line,
        style: line == poet.content ? _styleContentSpecial : _styleContent,
      );
    }).toList());
    if (poet.origin.translate != null && poet.origin.translate.isNotEmpty) {
      body.add(_padding);
      body.add(Flexible(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[600],
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: poet.origin.translate
                .map((line) => Text(
                      line,
                      style: _styleContent.copyWith(color: Colors.white),
                    ))
                .toList(),
          ),
        ),
      ));
    }
    body.add(_padding2x);
    return body;
  }

  Widget buildBottomNav() {}

  Widget _bottomAppBar([VoidCallback showTranslation, VoidCallback stared]) {
    List<Widget> options = <Widget>[
      SizedBox(
        width: 20,
      ),
      IconButton(
        icon: Icon(
          Icons.book,
          color: Colors.white,
        ),
        onPressed: showTranslation,
        tooltip: '翻译',
      ),
      SizedBox(
        width: 20,
      ),
      IconButton(
        icon: Icon(
          Icons.favorite_border,
          color: Colors.white,
        ),
        onPressed: stared,
        tooltip: '收藏',
      ),
    ];
    return BottomAppBar(
      color: Colors.lightBlue,
      child: Row(
        children: options,
      ),
      shape: CircularNotchedRectangle(),
    );
  }
}
