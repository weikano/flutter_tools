import 'package:flutter/material.dart';
import 'const.dart';
import 'api.dart';
import 'dart:ui';
import 'package:flutter_tools/basic.dart';

class ZhihuItemPage extends StatefulWidget {
  final ZhihuItem item;

  ZhihuItemPage({this.item});

  @override
  State<StatefulWidget> createState() {
    return _ZhihuItemState();
  }
}

class _ZhihuItemState extends StateWithFuture<ZhihuItemPage> {
  NewsContent _content;
  double _appBarHeight;

  @override
  void initState() {
    super.initState();
    _appBarHeight =
        window.physicalSize.width * 9 / 16 / window.devicePixelRatio;
    _loadContent();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: MediaQuery.removePadding(
        context: context,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildContent(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildContent() {
    List<Widget> contents = <Widget>[
      AspectRatio(aspectRatio: 16.0 / 9.0, child: _buildBackground()),
    ];
    if (_content != null) {
      contents.add(_buildQuestionTitle());
      contents.add(_buildAuthorInfo());
      contents.addAll(_buildParas());
      contents.add(SizedBox(
        height: 24,
      ));
    }
    return contents;
  }

  Widget _buildQuestionTitle() {
    if (_content.parsed.questionTitle != null &&
        _content.parsed.questionTitle.isNotEmpty) {
      return Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 12.0).copyWith(top: 12.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            _content.parsed.questionTitle,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    } else {
      return SizedBox(
        height: 12.0,
      );
    }
  }

  Widget _buildAuthorInfo() {
    return Padding(
      padding: const EdgeInsets.all(12.0).copyWith(top: 0, left: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Image.network(
            _content.parsed.avatar,
            width: 50,
            height: 50,
            fit: BoxFit.scaleDown,
          ),
          SizedBox(
            width: 6,
          ),
          Text(
            _content.parsed.author,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            width: 6,
          ),
          Text(
            _content.parsed.bio,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _buildParas() {
    return _content.parsed.ps.map((para) {
      Widget content;
      if (para.type == ContentPType.text) {
        content = Text(
          para.content,
          style: TextStyle(color: Colors.black87, fontSize: 15),
        );
      } else {
        content = Image.network(
          para.content,
          fit: BoxFit.fitWidth,
        );
      }
      return Padding(
        padding: const EdgeInsets.all(6.0),
        child: content,
      );
    }).toList();
  }

  Widget _buildBackground() {
    Widget mask = const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.0, 1.0),
          end: Alignment(0.0, 0.4),
          colors: <Color>[Color(0x60000000), Color(0x00000000)],
        ),
      ),
    );
    Widget title = Text(
      _title(),
      style: TextStyle(
        fontSize: 20,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
    );
    Widget desc;
    Widget image;
    if (_content != null) {
      desc = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12)
            .copyWith(top: 12, bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            title,
            SizedBox(
              height: 12,
            ),
            Text(
              '图片:${_content.imageSource}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
      image = Image.network(
        _content.image,
        fit: BoxFit.cover,
        height: _appBarHeight,
      );
    }

    Stack container = Stack(
      fit: StackFit.expand,
      children: <Widget>[
        mask,
      ],
    );

    if (_content == null) {
      return container;
    } else {
      return Stack(
        fit: StackFit.expand,
        children: <Widget>[
          image,
          mask,
          desc,
        ],
      );
    }
  }

  String _title() {
    if (_content != null) {
      return _content.title;
    }
    return widget.item.title;
  }

  void _loadContent() async {
    _content = await content(widget.item.id);
    setState(() {});
  }
}
