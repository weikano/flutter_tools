import 'package:flutter_tools/tools/network.dart' as NETWORK;
import 'const.dart' as CONST;
import 'package:flutter_tools/converter/json_converter.dart';

Future<List<CONST.Category>> categories() async {
  Map<String, dynamic> json = await NETWORK.get(CONST.XIANDU_CATEGORY);
  List results = optJSON(json, 'results');
  if (results != null) {
    return results.map((m) => CONST.Category.fromJSON(m)).toList();
  }
  return <CONST.Category>[];
}

Future<List<CONST.Category>> categoriesDebug() async {
  await Future.delayed(Duration(milliseconds: 500));
  return CONST.kCategories;
}

Stream<List<String>> gankDates() async* {
  await Future.delayed(Duration(milliseconds: 500));
  yield <String>[
    "2018-11-28",
    "2018-11-19",
    "2018-11-06",
    "2018-10-22",
    "2018-10-15",
    "2018-10-08",
    "2018-09-19",
    "2018-09-11",
    "2018-09-11",
    "2018-09-11",
    "2018-09-11",
    "2018-09-11",
    "2018-09-11",
    "2018-08-28",
    "2018-08-21",
    "2018-08-16",
    "2018-08-13",
    "2018-08-09",
    "2018-08-06",
    "2018-08-03",
    "2018-08-01",
    "2018-07-31",
    "2018-07-30",
    "2018-07-19",
    "2018-07-18",
    "2018-07-13",
    "2018-07-11",
  ];
}
