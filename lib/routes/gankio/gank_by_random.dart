import 'package:flutter/material.dart';

class GankRandomPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GankRandomState();
  }
}

class _GankRandomState extends State<GankRandomPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: Colors.deepOrange,
      child: Center(
        child: Text('随机列表'),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
