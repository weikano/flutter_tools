import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'base_info_page.dart';
import 'dart:io';

class DeviceInfoPage extends StatelessWidget {
  static var routeName = '/deviceinfo';

  @override
  Widget build(BuildContext context) {
    Widget child = _UnknownPlatform();
    if (Platform.isAndroid) {
      child = _AndroidInfoPage();
    } else if (Platform.isIOS) {
      child = _IOSInfoPage();
    }
    return BaseInfoPage(
      child: child,
      title: '关于手机',
    );
  }
}

class _UnknownPlatform extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '${Platform.operatingSystem}',
        style: TextStyle(
          fontSize: 32,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}

class _IOSInfoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _IOSInfoState();
  }
}

class _IOSInfoState extends State<_IOSInfoPage> {
  Map<String, dynamic> deviceInfo = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
    _readInfo();
  }

  _readInfo() async {
    var _info = DeviceInfoPlugin();
    var _ios = await _info.iosInfo;
    setState(() {
      deviceInfo = <String, dynamic>{
        'name': _ios.name,
        'systemName': _ios.systemName,
        'model': _ios.model,
        'localizedModle': _ios.localizedModel,
        'identifierForVendor': _ios.identifierForVendor,
        'isPhysicalDevice': _ios.isPhysicalDevice,
        'utsname.sysname': _ios.utsname.sysname,
        'utsname.nodename': _ios.utsname.nodename,
        'utsname.release': _ios.utsname.release,
        'utsname.version': _ios.utsname.version,
        'utsname.machine': _ios.utsname.machine,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: BaseInfoPage.buildInfos(context, deviceInfo),
    );
  }
}

class _AndroidInfoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AndroidInfoState();
  }
}

class _AndroidInfoState extends State<_AndroidInfoPage> {
  Map<String, dynamic> deviceData = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
    _readAndroidInfo();
  }

  _readAndroidInfo() async {
    var info = await DeviceInfoPlugin().androidInfo;
    setState(() {
      deviceData = <String, dynamic>{
        'brand': info.brand,
        'securityPatch': info.version.securityPatch,
        'sdkInt': info.version.sdkInt,
        'release': info.version.release,
        'previewSdkInt': info.version.previewSdkInt,
        'incremental': info.version.incremental,
        'codename': info.version.codename,
        'baseOs': info.version.baseOS,
        'board': info.board,
        'bootloader': info.bootloader,
        'device': info.device,
        'display': info.display,
        'fingerprint': info.fingerprint,
        'hardware': info.hardware,
        'host': info.host,
        'id': info.id,
        'manufacture': info.manufacturer,
        'modle': info.model,
        'product': info.product,
        'supported32BitAbis': info.supported32BitAbis,
        'supported64BitAbis': info.supported64BitAbis,
        'supportedAbis': info.supportedAbis,
        'tags': info.tags,
        'type': info.type,
        'isPhysicalDevice': info.isPhysicalDevice,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: BaseInfoPage.buildInfos(context, deviceData),
    );
  }
}
