import 'dart:ui';
import 'package:flutter/material.dart';
import 'base_info_page.dart';

class ScreenInfoPage extends StatefulWidget {
  static var routeName = '/screeninfo';

  @override
  State<StatefulWidget> createState() {
    return _ScreenInfoState();
  }
}

class _ScreenInfoState extends State<ScreenInfoPage> {
  Map<String, dynamic> _info = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
    setState(() {
      _info = {
        'devicePixelRatio': window.devicePixelRatio,
        'physicalSize': window.physicalSize,
        'windowPadding': window.padding,
        'viewInsets': window.viewInsets,
        'textScaleFactor': window.textScaleFactor,
        '24HourFormat': window.alwaysUse24HourFormat,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseInfoPage(
      child: ListView(
        children: BaseInfoPage.buildInfos(context, _info),
      ),
      title: '屏幕信息',
    );
  }
}
