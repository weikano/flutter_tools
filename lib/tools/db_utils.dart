import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_tools/routes/zhihu/db_const.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';

class _DbUtils {
  static int _version = 4;
  static String _name = 'poet.db';
  static String _asset = 'assets/database';
  static Database _db;
  static final _DbUtils _instance = _DbUtils._internal();
  Lock _lock = Lock(reentrant: true);

  _DbUtils._internal();

  factory _DbUtils() => _instance;

  Future<Database> getDatabase(bool readOnly) async {
    if (_db == null) {
      await _lock.synchronized(() async {
        if (_db == null) {
          var databasePath = await getDatabasesPath();
          var path = join(databasePath, _name);
          try {
            _db = await _openDatabaseWrapped(path, readOnly: false);
          } on Exception catch (e) {
            print(e);
//            if (_db == null) {
            ///copy db file from assets
            ByteData data = await rootBundle.load(join(_asset, _name));
            List<int> bytes =
                data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
            await File(path).writeAsBytes(bytes);
            _db = await _openDatabaseWrapped(path, readOnly: readOnly);
//            }
          }
        }
      });
    }
    return _db;
  }

  Future<Database> _openDatabaseWrapped(String path,
      {bool readOnly = true, bool singleInstance = true}) async {
    return openDatabase(path,
        readOnly: readOnly,
        singleInstance: singleInstance,
        version: _version,
        onUpgrade: _onUpgrade);
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('onUpgrade from $oldVersion to $newVersion');
    await db.transaction((txn) async {
      ZHIHU_TABLE.forEach((it) {
        txn.execute(it);
      });
      ZHIHU_INDEX.forEach((it) {
        txn.execute(it);
      });
    });
  }
}

///所有数据库操作类 with GetDatabaseMixin
mixin GetDatabaseMixin {
  Future<Database> getDatabase(bool readOnly) async {
    return _DbUtils().getDatabase(readOnly);
  }
}

abstract class DatabaseOpertor<T> {
  Map<String, dynamic> toDatabase(T t);
  T fromDatabase(Map<String, dynamic> item);
}
