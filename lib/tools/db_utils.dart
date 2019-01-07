import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';

class DbUtils {
  static int VERSION = 1;
  static String _DB_NAME = 'poet.db';
  static String _ASSET = 'assets/database';
  static Database _db;
  static final DbUtils _instance = DbUtils._internal();
  Lock _lock = Lock(reentrant: true);

  DbUtils._internal();

  factory DbUtils() => _instance;

  Future<Database> getDatabase(bool readOnly) async {
    if (_db == null) {
      await _lock.synchronized(() async {
        if (_db == null) {
          var databasePath = await getDatabasesPath();
          var path = join(databasePath, _DB_NAME);
          try {
            _db = await _openDatabaseWrapped(path, readOnly: false);
          } on Exception catch (e) {
            print(e);
//            if (_db == null) {
            ///copy db file from assets
            ByteData data = await rootBundle.load(join(_ASSET, _DB_NAME));
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
        version: VERSION,
        onUpgrade: _onUpgrade);
  }

  OnDatabaseVersionChangeFn _onUpgrade =
      (Database db, int oldVersion, int newVersion) {
    print('oldVersion $oldVersion and newVersion $newVersion');
  };
}
