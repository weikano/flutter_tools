import 'package:flutter/material.dart';
import 'const.dart';
import 'api.dart';
import 'dart:ui';
import 'package:flutter_tools/basic.dart';

class ZhihuStoryPage extends StatefulWidget {
  final ZhihuStoryBase item;

  ZhihuStoryPage({this.item});

  @override
  State<StatefulWidget> createState() {
    return _ZhihuStoryState();
  }
}

const double _padding = 12.0;
const double _aspectRatio = 16.0 / 9.0;

class _ZhihuStoryState extends StateWithFuture<ZhihuStoryPage> {
  final double _titleSize = 20;
  final double _paraSize = 16;
  final double _imageSourceSize = 14;
  final double _questionTitleSize = 16;
  final double _authorSize = 16;
  final double _bioSize = 14;
  final double _avatarSize = 24;

  final EdgeInsets _paddingParas =
      const EdgeInsets.symmetric(vertical: _padding / 2, horizontal: _padding);

  ZhihuStory _content;
  ZhihuStoryExtra _extra;
  double _appBarHeight;

  @override
  void initState() {
    super.initState();
    _appBarHeight =
        window.physicalSize.width * _aspectRatio / window.devicePixelRatio;
    _loadContent();
  }

  @override
  Widget build(BuildContext context) {
    if (_content == null) {
      return Material(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Material(
      child: MediaQuery.removePadding(
        context: context,
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildContent(),
              ),
            ),
            _extra == null
                ? null
                : _ExtraWidget(
                    extra: _extra,
                  ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildContent() {
    List<Widget> contents = <Widget>[
      AspectRatio(aspectRatio: _aspectRatio, child: _buildBackground()),
    ];
    if (_content != null) {
      contents.add(_buildQuestionTitle());
      contents.add(_buildAuthorInfo());
      contents.addAll(_buildParas());
      contents.add(SizedBox(
        height: 80,
      ));
    }
    return contents;
  }

  Widget _buildQuestionTitle() {
    if (_content.parsed.questionTitle != null &&
        _content.parsed.questionTitle.isNotEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: _padding)
            .copyWith(top: _padding),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            _content.parsed.questionTitle,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.black,
              fontSize: _questionTitleSize,
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
      padding: const EdgeInsets.all(_padding).copyWith(bottom: _padding / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Image.network(
            _content.parsed.avatar,
            width: _avatarSize,
            height: _avatarSize,
            fit: BoxFit.scaleDown,
          ),
          SizedBox(
            width: 3,
          ),
          Text(
            _content.parsed.author,
            style: TextStyle(
              fontSize: _authorSize,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            width: 3,
          ),
          Expanded(
            child: Text(
              _content.parsed.bio,
              textAlign: TextAlign.start,
              maxLines: 2,
              style: TextStyle(
                color: Colors.grey,
                fontSize: _bioSize,
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _buildParas() {
    return _content.parsed.ps.map((para) {
      Widget content;
      if (para.type == ZhihuParaType.text) {
        content = Text(
          para.content,
          style: TextStyle(color: Colors.black87, fontSize: _paraSize),
        );
      } else {
        content = Image.network(
          para.content,
          fit: BoxFit.fitWidth,
        );
      }
      return Padding(
        padding: _paddingParas,
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
        fontSize: _titleSize,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
    );
    Widget desc;
    Widget image;
    if (_content != null) {
      desc = Padding(
        padding: const EdgeInsets.all(_padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            title,
            SizedBox(
              height: _padding,
            ),
            Text(
              '图片:${_content.imageSource}',
              style: TextStyle(
                color: Colors.white,
                fontSize: _imageSourceSize,
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
    _extra = await extra(widget.item.id);
    setState(() {});
  }
}

class _ExtraWidget extends StatelessWidget {
  final ZhihuStoryExtra extra;
  _ExtraWidget({this.extra});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Stack(
              children: <Widget>[
                IconButton(icon: Icon(Icons.message), onPressed: () {}),
                Positioned(
                  top: 4,
                  right: 4,
                  child: Text(
                    extra.total.toString(),
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: _padding,
            ),
            Stack(
              children: <Widget>[
                IconButton(icon: Icon(Icons.favorite), onPressed: () {}),
                Positioned(
                  top: 4,
                  right: 4,
                  child: Text(
                    extra.popularity.toString(),
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
