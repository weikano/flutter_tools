import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_tools/basic.dart';
import 'package:flutter_tools/routes/poet/collection_list.dart';
import 'package:flutter_tools/routes/poet/const_fix.dart';
import 'package:flutter_tools/routes/poet/db_helper.dart';
import 'package:flutter_tools/routes/poet/styles.dart';
import 'package:flutter_tools/routes/poet/widgets.dart';
import 'package:flutter_tools/widgets/commons.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

///作品集tab
class CollectionTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CollectionTabState();
  }
}

class _CollectionTabState extends State<CollectionTab>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (_,
          AsyncSnapshot<ApiResponse<Map<PoetTheme, List<Collection>>>>
              snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: ReloadButton(),
          );
        } else if (snapshot.hasData) {
          var data = snapshot.data;
          if (data.fail()) {
            return Center(
              child: ReloadButton(),
            );
          } else if (data.success()) {
            return _buildContent(data.response);
          }
        }
        return LoadingIndicator();
      },
      future: DbHelper().allCollectionsGroupByTheme(),
      initialData: ApiResponse<Map<PoetTheme, List<Collection>>>.ofLoading(),
    );
  }

  Widget _buildContent(Map<PoetTheme, List<Collection>> data) {
    return Scrollbar(
        child: CustomScrollView(
      slivers: _buildContentInner(data),
    ));
  }

  List<Widget> _buildContentInner(Map<PoetTheme, List<Collection>> data) {
    List<Widget> widgets = <Widget>[];
    data.forEach((PoetTheme key, List<Collection> cs) {
      var item = SliverStickyHeader(
        header: _buildHeader(key, cs),
        sliver: SliverGrid(
          delegate: SliverChildBuilderDelegate((BuildContext ctx, int index) {
            var item = cs[index];
            return CollectionItemWidget(item);
          }, childCount: min(cs.length, 12)),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, crossAxisSpacing: 4.0, mainAxisSpacing: 4.0),
        ),
      );
      widgets.add(item);
    });
    return widgets;
  }

  Widget _buildHeader(PoetTheme key, List<Collection> cs) {
    bool more = cs.length > 12;
    var label = Text(
      key.name,
      style: TextStyle(
          fontSize: 16, color: Colors.deepOrange, fontWeight: FontWeight.w700),
    );
    var body = more
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(child: label),
              Text(
                '更多 >',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          )
        : label;
    return GestureDetector(
      onTap: () {
        if (more) {
          _jumpToCollections(context, key);
        }
        print(key);
      },
      child: Container(
        decoration: BoxDecoration(color: headerBackgroundColor),
        padding: const EdgeInsets.only(left: 12, top: 4, bottom: 4, right: 12),
        child: body,
      ),
    );
  }

  void _jumpToCollections(BuildContext context, PoetTheme theme) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => CollectionListByThemePage.factory(theme)));
  }

  @override
  bool get wantKeepAlive => true;
}
