import 'package:flutter/material.dart';
import 'package:flutter_tools/basic.dart';
import 'package:intl/intl.dart';
import 'api.dart';
import 'const.dart';
import 'package:flutter_tools/widgets/commons.dart';

class ZhihuCommentsPage extends StatefulWidget {
  ///storyId
  final int storyId;
  final int long;
  final int short;

  ///评论数量
  final int count;

  ZhihuCommentsPage({this.storyId, this.count, this.long, this.short});

  @override
  State<StatefulWidget> createState() {
    return _ZhihuCommentsState();
  }
}

class _ZhihuCommentsState extends State<ZhihuCommentsPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('${widget.count}条点评'),
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return StreamBuilder(
      builder: (BuildContext _,
          AsyncSnapshot<ApiResponse<List<ZhihuComment>>> snapshot) {
        if (snapshot.hasError || (snapshot.hasData && snapshot.data.fail())) {
          return Center(
            child: ReloadButton(
              onPressed: () {
                getAllComments(widget.storyId);
              },
            ),
          );
        } else if (snapshot.hasData) {
          var data = snapshot.data;
          if (data.loading()) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (data.success()) {
            return _buildCommentsList(data.response);
          }
        }
      },
      stream: getAllComments(widget.storyId),
      initialData: ApiResponse<List<ZhihuComment>>.ofLoading(),
    );
  }

  Widget _buildCommentsList(List<ZhihuComment> comments) {
    return Scrollbar(
      child: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            var item = comments[index];
            bool showTypeSection = false;
            if (index == 0 ||
                (index > 0 &&
                    comments[index].type != comments[index - 1].type)) {
              showTypeSection = true;
            }
            bool long = item.type == ZhihuCommentType.long;
            if (long) {
              return _buildLongCommentItem(item, showTypeSection);
            } else {
              return _buildShortCommentItem(item, showTypeSection);
            }
          },
          separatorBuilder: (BuildContext _, int index) {
            return _divider;
          },
          itemCount: comments.length),
    );
  }

  var _divider = Divider(
    height: 4,
    color: Colors.black,
  );

  double _sectionFontSize = 16;
  double _authorFontSize = 16;
  double _timeFontSize = 12;
  double _replySize = 16;
  FontWeight _sectionFontWeight = FontWeight.w500;
  FontWeight _authorFontWeight = FontWeight.w500;
  Color _sectionColor = Colors.blue;
  Color _authorColor = Colors.black;
  Color _timeColor = Colors.grey;

  EdgeInsets _padding = const EdgeInsets.all(12.0);
  double _avatarSize = 24;

  Widget _buildLongCommentItem(ZhihuComment item, bool showTypeSection) {
    return _buildShortCommentItem(item, showTypeSection);
  }

  Widget _buildSection(ZhihuComment item) {
    return Padding(
      padding: _padding,
      child: Text(
        item.type == ZhihuCommentType.long
            ? '${widget.long}条长评'
            : '${widget.short}条短评',
        style: TextStyle(
          fontSize: _sectionFontSize,
          fontWeight: _sectionFontWeight,
          color: _sectionColor,
        ),
        textAlign: TextAlign.start,
        maxLines: 1,
      ),
    );
  }

  Widget _buildShortCommentItem(ZhihuComment item, bool showTypeSection) {
    Widget section = Container();
    Widget replyTo = Container();
    if (showTypeSection) {
      section = _buildSection(item);
    }
    if (item.replyTo != null) {
      replyTo = _buildReplyTo(item.replyTo);
    }
    Widget child = InkWell(
      onTap: () {},
      child: Padding(
        padding: _padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildAuthorLine(item),
            SizedBox(
              height: _padding.top / 2,
            ),
            Text(
              item.content,
              style: TextStyle(
                fontSize: _authorFontSize,
              ),
              textAlign: TextAlign.start,
            ),
            replyTo,
            SizedBox(
              height: _padding.top,
            ),
            Text(
              DateFormat('yyyy-MM-dd HH:mm').format(item.time),
              style: TextStyle(
                fontSize: _timeFontSize,
                color: _timeColor,
              ),
            ),
          ],
        ),
      ),
    );
    if (showTypeSection) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          section,
          _divider,
          child,
        ],
      );
    } else {
      return child;
    }
  }

  Widget _buildAuthorLine(ZhihuComment item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(_avatarSize / 2)),
          child: Image.network(
            item.avatar,
            width: _avatarSize,
            height: _avatarSize,
          ),
        ),
        SizedBox(
          width: _padding.left / 2,
        ),
        Text(
          item.author,
          style: TextStyle(
            fontWeight: _authorFontWeight,
            fontSize: _authorFontSize,
            color: _authorColor,
          ),
          textAlign: TextAlign.start,
        ),
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Icon(
                Icons.thumb_up,
                size: _avatarSize / 2,
                color: Colors.grey,
              ),
              SizedBox(
                width: 4,
              ),
              Text(item.likes.toString()),
            ],
          ),
          fit: FlexFit.tight,
        ),
      ],
    );
  }

  Widget _buildReplyTo(ZhihuCommentReplyTo reply) {
    if (reply.status == 0) {
      return Text.rich(TextSpan(
        children: <TextSpan>[
          TextSpan(
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: _replySize,
                color: Colors.black,
              ),
              text: '//${reply.author}: '),
          TextSpan(
            text: reply.content,
            style: TextStyle(
              fontSize: _replySize,
              color: Colors.grey,
            ),
          )
        ],
      ));
    } else {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        padding: _padding,
        child: Center(
          child: Text(
            reply.errMsg,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      );
    }
  }
}
