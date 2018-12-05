import 'package:flutter/material.dart';

class BaseInfoPage extends StatelessWidget {
  final String title;

  BaseInfoPage({this.child, this.title});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
          leading: Navigator.canPop(context)
              ? IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              : null,
        ),
        body: child,
      ),
    );
  }

  static List<Widget> buildInfos(
      BuildContext context, Map<String, dynamic> info) {
    var infos = <Widget>[];
    info.entries.forEach((MapEntry<String, dynamic> entry) {
      infos.add(buildInfo(context, entry.key, entry.value));
    });
    return infos;
  }

  static Widget buildInfo(BuildContext context, String key, dynamic value) {
    var textStyle = Theme.of(context).textTheme.title;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: SizedBox(
        height: 48,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: Row(
                  children: <Widget>[
                    Text(
                      key,
                      style: textStyle.copyWith(color: Colors.black),
                    ),
                    Expanded(
                        child: Text(
                      value.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textStyle.copyWith(
                          color: Colors.black38,
                          fontSize: textStyle.fontSize - 2),
                      textAlign: TextAlign.right,
                    ))
                  ],
                ),
              ),
            ),
            Divider(
              height: 1.0,
            )
          ],
        ),
      ),
    );
  }
}
