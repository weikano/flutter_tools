import 'package:flutter/material.dart';
import 'package:flutter_tools/widgets/commons.dart';
import 'api.dart';
import 'const.dart';

class GankCategoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GankCategoryState();
  }
}

class _GankCategoryState extends State<GankCategoryPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: categories(),
      builder: (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
        Widget body = Center(
          child: CircularProgressIndicator(),
        );
        if (snapshot.hasError) {
          body = ReloadButton(
            onPressed: () {
              print('reload');
            },
          );
        } else if (snapshot.hasData) {
          return _buildCategoryPage(snapshot.data);
        }
        return body;
      },
    );
  }

  Widget _buildCategoryPage(List<Category> data) {
    return DefaultTabController(
      length: data.length,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            bottom: TabBar(
                isScrollable: true,
                tabs: data.map((d) {
                  return Tab(
                    text: d.name,
                  );
                }).toList()),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Wrap(
                spacing: 10,
                runSpacing: 4,
                direction: Axis.vertical,
                children: data.map((d) {
                  return _buildCategoryChip(d);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(Category d) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          child: Chip(
            label: Text(
              d.name,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.deepPurple,
          ),
        ),
      ),
      onTap: () {
        print(d.code);
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
