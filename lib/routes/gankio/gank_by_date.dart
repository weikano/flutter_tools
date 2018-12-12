import 'package:flutter/material.dart';
import 'package:flutter_tools/widgets/commons.dart';
import 'api.dart';

class GankDatePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GankDateState();
  }
}

class _GankDateState extends State<GankDatePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        Widget content = Center(
          child: CircularProgressIndicator(),
        );
        if (snapshot.hasError) {
          content = Center(
            child: ReloadButton(
              onPressed: () {
                print('重载');
              },
            ),
          );
        } else if (snapshot.hasData) {
          List<String> dates = snapshot.data;
          content = _buildChips(dates);
        }
        return content;
      },
      stream: gankDates(),
    );
  }

  Widget _buildChips(List<String> dates) {
    return Center(
      child: SingleChildScrollView(
        child: Wrap(
          spacing: 10,
          runSpacing: 12,
          children: dates.map((d) {
            return GestureDetector(
              child: Chip(
                backgroundColor: Colors.teal,
                label: Text(
                  d,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              onTap: () {
                print('selected date is $d');
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
