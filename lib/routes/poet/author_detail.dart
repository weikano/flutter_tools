import 'package:flutter/material.dart';
import 'package:flutter_tools/routes/poet/author_works_by_kind.dart';
import 'package:flutter_tools/routes/poet/const_fix.dart';
import 'package:flutter_tools/utils.dart';

class AuthorDetailPage extends StatelessWidget {
  final Author author;

  AuthorDetailPage.factory(this.author);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('作者简介'),
          leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              }),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () {
                openWebView(author.wiki);
              },
            ),
          ],
        ),
        body: _Body.factory(author),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  final Author author;

  _Body.factory(this.author);

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

const _styleName = TextStyle(
  fontSize: 20,
  color: Colors.black,
  fontWeight: FontWeight.bold,
);

const _styleNormal = TextStyle(
  fontSize: 16,
  color: Colors.black,
);

const _styleIntro = TextStyle(
  fontSize: 16,
  color: Colors.deepOrange,
);

var _styleBio = _styleNormal.copyWith();

var _styleWorkLabel = _styleNormal.copyWith(fontSize: 17);
var _styleWorkLabelZero = _styleWorkLabel.copyWith(
  color: Colors.deepOrange,
);
var _styleWorkValue = _styleWorkLabel.copyWith(
  fontSize: 15,
);

var _styleWorkValueZero = _styleWorkValue.copyWith(
  color: Colors.deepOrange,
);

const _dividerLarge = const Divider(
  height: 24,
  color: Colors.transparent,
);
const _dividerNormal = const Divider(
  height: 12,
  color: Colors.transparent,
);

class _State extends State<_Body> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _dividerLarge,
            Text(widget.author.name, style: _styleName),
            _dividerNormal,
            Text(
              "[${widget.author.dynasty}] ${widget.author.yearOfBirth}~${widget.author.yearOfDeath}",
              style: _styleNormal,
            ),
            _dividerNormal,
            Text(
              "简介",
              style: _styleIntro,
            ),
            _dividerNormal,
            Text(
              widget.author.intro,
              style: _styleBio,
            ),
            _dividerNormal,
            Text(
              '作品 / ${widget.author.countOfWorks}',
              style: _styleIntro,
            ),
            _dividerNormal,
            SizedBox(
              width: double.infinity,
              child: Align(
                alignment: Alignment.center,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: _buildWorksIcon(widget.author),
                ),
              ),
            ),
            _dividerLarge,
          ],
        ),
      ),
    );
  }

  List<Widget> _buildWorksIcon(Author author) {
    return <Widget>[
      _WorkLabel.factory(author, "诗", "shi", author.countOfShi),
      _WorkLabel.factory(author, "词", "ci", author.countOfCi),
      _WorkLabel.factory(author, "曲", "qu", author.countOfQu),
      _WorkLabel.factory(author, "赋", "fu", author.countOfFu),
      _WorkLabel.factory(author, "文", "wen", author.countOfWen),
    ];
  }
}

class _WorkLabel extends StatelessWidget {
  var _size = 50.0;
  final Author author;
  final String label;
  final String id;
  final int count;
  _WorkLabel.factory(this.author, this.label, this.id, this.count);
  @override
  Widget build(BuildContext context) {
    bool zero = count == 0;
    return GestureDetector(
      onTap: () {
        if (!zero) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      AuthorWorksByKind.factory(author, id, label)));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: zero ? Colors.deepOrange : Colors.grey, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(_size)),
        ),
        child: SizedBox(
          height: _size,
          width: _size,
          child: Align(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  label,
                  style: zero ? _styleWorkLabelZero : _styleWorkLabel,
                ),
                Divider(
                  height: 2,
                  color: Colors.transparent,
                ),
                Text(
                  "$count",
                  style: zero ? _styleWorkValueZero : _styleWorkValue,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
