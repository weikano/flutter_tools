import 'package:flutter/material.dart';
import 'package:flutter_tools/routes/poet/const_fix.dart';
import 'package:flutter_tools/routes/poet/db_helper.dart';
import 'package:flutter_tools/routes/poet/widgets.dart';
import 'package:flutter_tools/widgets/commons.dart';

///作品集列表
class CollectionListByThemePage extends StatelessWidget {
  final PoetTheme theme;
  CollectionListByThemePage.factory(this.theme);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(theme.name),
          leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: _Body(theme),
      ),
    );
  }
}

class _Body extends NormalGridPage<Collection> {
  final PoetTheme theme;

  _Body(this.theme)
      : super(
            future: DbHelper().allCollectionsByKind(theme),
            builder: (BuildContext ctx, data, prev) {
              return CollectionItemWidget(data);
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, mainAxisSpacing: 4, crossAxisSpacing: 4));
}
