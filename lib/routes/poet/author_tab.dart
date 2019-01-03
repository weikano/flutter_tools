import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_tools/basic.dart';
import 'package:flutter_tools/routes/poet/author_detail.dart';
import 'package:flutter_tools/routes/poet/const_fix.dart';
import 'package:flutter_tools/routes/poet/db_helper.dart';
import 'package:flutter_tools/routes/poet/styles.dart';
import 'package:flutter_tools/widgets/commons.dart';

///作者tab
class AuthorTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<AuthorTab> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        builder:
            (_, AsyncSnapshot<ApiResponse<Map<Dynasty, List<Author>>>> data) {
          if (data.hasError) {
            return ReloadButton();
          } else if (data.hasData) {
            var d = data.data;
            if (d.fail()) {
              return ReloadButton();
            } else if (d.success()) {
              return _buildAuthorList(_, d.response);
            }
          }
          return LoadingIndicator();
        },
        future: DbHelper().allAuthorsByDynasty(),
        initialData: ApiResponse<Map<Dynasty, List<Author>>>.ofLoading());
  }

  Widget _buildAuthorList(
      BuildContext buildContext, Map<Dynasty, List<Author>> response) {
    return Scrollbar(
      child: CustomScrollView(
        slivers: _buildAuthorListInner(buildContext, response),
      ),
    );
  }

  List<Widget> _buildAuthorListInner(
      BuildContext buildContext, Map<Dynasty, List<Author>> data) {
    List<Widget> widges = <Widget>[];
    data.forEach((Dynasty key, List<Author> authors) {
      var item = SliverStickyHeader(
        header: _buildHeader(key),
        sliver: SliverList(
            delegate: SliverChildBuilderDelegate((_, int index) {
          return _AuthorItemWidget(authors[index]);
        }, childCount: authors.length)),
      );
      widges.add(item);
    });
    return widges;
  }

  Widget _buildHeader(Dynasty key) {
    return Container(
      decoration: BoxDecoration(color: headerBackgroundColor),
      child: Text(key.name,
          style: baseTextStyle.copyWith(
              fontSize: 16,
              color: Colors.deepOrange,
              fontWeight: FontWeight.w700)),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _AuthorItemWidget extends StatelessWidget {
  final Author author;
  _AuthorItemWidget(this.author);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _jumpToAuthorDetail(context, author);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text(
                    author.name,
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontWeight: FontWeight.w300),
                  ),
                ),
                SizedBox(
                  width: 4,
                ),
                Row(
                  children: _buildWorkIcons(author),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Divider(
              height: 2,
            ),
          ),
        ],
      ),
    );
    ;
  }

  void _jumpToAuthorDetail(BuildContext context, Author author) {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => AuthorDetailPage.factory(author)));
  }

  List<Widget> _buildWorkIcons(Author author) {
    List<Widget> icons = <Widget>[];
    icons.add(_WorkIcon('诗', author.countOfShi == 0));
    icons.add(_WorkIcon('词', author.countOfCi == 0));
    icons.add(_WorkIcon('曲', author.countOfQu == 0));
    icons.add(_WorkIcon('赋', author.countOfFu == 0));
    icons.add(_WorkIcon('文', author.countOfWen == 0));
    return icons;
  }
}

class _WorkIcon extends StatelessWidget {
  final _emptyColor = Colors.deepOrange;
  final _normalColor = Colors.black45;
  final String label;
  final bool empty;
  _WorkIcon(this.label, this.empty);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: empty ? _emptyColor : _normalColor),
      ),
      padding: const EdgeInsets.all(4),
      child: SizedBox.fromSize(
        size: Size.square(18),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
                fontSize: 12, color: empty ? _emptyColor : _normalColor),
          ),
        ),
      ),
    );
  }
}
