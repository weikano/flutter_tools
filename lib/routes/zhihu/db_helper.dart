import 'package:flutter_tools/routes/zhihu/const.dart';
import 'package:flutter_tools/routes/zhihu/db_const.dart';
import 'package:flutter_tools/tools/db_utils.dart';

class ZhihuDbHelper with GetDatabaseMixin {
  ZhihuDbHelper._internal();
  static final ZhihuDbHelper _singleton = ZhihuDbHelper._internal();
  factory ZhihuDbHelper() {
    return _singleton;
  }

  Future<void> saveTopItem(List<ZhihuTopItem> items) async {
    var db = await getDatabase(false);
    db.transaction((tnx) {
      db.execute(TRUNCATE_TOP_ITEM);
      for (var item in items) {
        tnx.execute(INSERT_TOP_ITEM, item.toValues());
      }
    });
  }

  Future<List<ZhihuTopItem>> allTopItems() async {
    var db = await getDatabase(false);
    var datas = await db.query('zhihu_top_story');
    return datas.map((item) => ZhihuTopItem.fromJSON(item)).toList();
  }
}
