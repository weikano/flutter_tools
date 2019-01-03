import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_tools/basic.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';
import 'const_fix.dart';

class DbHelper {
  static String _DB_NAME = 'poet.db';
  static String _ASSET = 'assets/database';
  static Database _db;
  static final DbHelper _instance = DbHelper._internal();
  Lock _lock = Lock(reentrant: true);

  DbHelper._internal();

  factory DbHelper() => _instance;

  Future<Database> _getDatabase(bool readOnly) async {
    if (_db == null) {
      await _lock.synchronized(() async {
        if (_db == null) {
          var databasePath = await getDatabasesPath();
          var path = join(databasePath, _DB_NAME);
          try {
            _db = await openDatabase(path,
                readOnly: readOnly, singleInstance: true);
          } on Exception catch (e) {
            print(e);
//            if (_db == null) {
            ///copy db file from assets
            ByteData data = await rootBundle.load(join(_ASSET, _DB_NAME));
            List<int> bytes =
                data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
            await File(path).writeAsBytes(bytes);
            _db = await openDatabase(path,
                readOnly: readOnly, singleInstance: true);
//            }
          }
        }
      });
    }
    return _db;
  }

  ///所有作者
  Future<ApiResponse<List<Author>>> allAuthors() async {
    List<
        Map<String,
            dynamic>> authors = await (await _getDatabase(true)).rawQuery(
        'select A.* from authors a, dynasties b on a.dynasty = b.name order by b.start_year, a.id');
    return ApiResponse.ofSuccess(
        authors.map((it) => Author.fromDatabase(it)).toList());
  }

  ///所有朝代
  Future<ApiResponse<List<Dynasty>>> allDynasties() async {
    List<Map<String, dynamic>> dynasties = await (await _getDatabase(true))
        .rawQuery('SELECT id, name, intro FROM dynasties ORDER BY start_year');
    return ApiResponse.ofSuccess(
        dynasties.map((m) => Dynasty.fromDatabase(m)).toList());
  }

  ///所有作品集
  Future<ApiResponse<List<Collection>>> allCollections() async {
    Database db = await _getDatabase(true);
    List<Map<String, dynamic>> collections = await db.rawQuery(
        "SELECT * FROM collections ORDER BY kind_id, show_order, name");
    return ApiResponse.ofSuccess(
        collections.map((m) => Collection.fromDatabase(m)).toList());
  }

  ///作品集按主题排序
  Future<ApiResponse<Map<PoetTheme, List<Collection>>>>
      allCollectionsGroupByTheme() async {
    var cs = (await allCollections()).response;
    Map<PoetTheme, List<Collection>> result = <PoetTheme, List<Collection>>{};
    cs.forEach((c) {
      PoetTheme key = PoetTheme.simple(c.kind_id, c.kind);
      var ds = result[key];
      if (ds == null) {
        ds = <Collection>[];
      }
      ds.add(c);
      result[key] = ds;
    });
    return ApiResponse.ofSuccess(result);
  }

  ///按朝代前后列出所有作者
  Future<ApiResponse<Map<Dynasty, List<Author>>>> allAuthorsByDynasty() async {
    var as = (await allAuthors()).response;
    Map<Dynasty, List<Author>> result = <Dynasty, List<Author>>{};
    as.forEach((a) {
      Dynasty key = Dynasty.simple(a.dynasty);
      var ds = result[key];
      if (ds == null) {
        ds = <Author>[];
      }
      ds.add(a);
      result[key] = ds;
    });
    return ApiResponse.ofSuccess(result);
  }

  ///所有主题
  Future<ApiResponse<List<PoetTheme>>> allThemes() async {
    List<Map<String, dynamic>> collections = await (await _getDatabase(true))
        .rawQuery('SELECT id, name FROM collection_kinds ORDER BY show_order');
    return ApiResponse.ofSuccess(
        collections.map((m) => PoetTheme.fromDatabase(m)).toList());
  }

  ///根据主题查询所有分类
  Future<ApiResponse<List<Collection>>> allCollectionsByKind(
      PoetTheme kind) async {
    var data = await (await _getDatabase(true)).rawQuery(
        "SELECT * from collections WHERE kind_id=? ORDER BY show_order",
        [kind.id]);
    return ApiResponse.ofSuccess(
        data.map((m) => Collection.fromDatabase(m)).toList());
  }

  ///根据作品集显示引用
  Future<ApiResponse<List<CollectionQuote>>> allQuotesByCollection(
      Collection collection) async {
    var data = await (await _getDatabase(true)).rawQuery(
        "SELECT * FROM collection_quotes WHERE collection_id=? ORDER BY show_order",
        [collection.id]);
    return ApiResponse.ofSuccess(
        data.map((m) => CollectionQuote.fromDatabase(m)).toList());
  }

  ///根据作品集引用显示作品
  Future<ApiResponse<Work>> workDetailByQuoteId(CollectionQuote quote) async {
    var data = await (await _getDatabase(true)).rawQuery(
        "SELECT b.* FROM quotes a, works b on a.work_id = b.id WHERE a.id = ?",
        [quote.quote_id]);
    if (data != null && data.isNotEmpty) {
      return ApiResponse.ofSuccess(Work.fromDatabase(data[0]));
    } else {
      return ApiResponse.ofError(Exception(['找不到对应的作品']));
    }
  }

  ///作者名下所有作品
  Future<ApiResponse<List<Work>>> allWorksByAuthor(Author author) async {
    List<Map<String, dynamic>> collections = await (await _getDatabase(true))
        .rawQuery(
            'SELECT * FROM works WHERE author_id=? ORDER BY id', [author.id]);
    return ApiResponse.ofSuccess(
        collections.map((m) => Work.fromDatabase(m)).toList());
  }

  ///分类名下所有作品
  Future<ApiResponse<List<CollectionWork>>> allCollectionItemsById(
      Collection collection) async {
    List<
        Map<String,
            dynamic>> items = await (await _getDatabase(true)).rawQuery(
        "SELECT * FROM collection_works WHERE collection_id=? ORDER BY show_order",
        [collection.id]);
    return ApiResponse.ofSuccess(
        items.map((it) => CollectionWork.fromDatabase(it)).toList());
  }

  ///作品详情
  Future<ApiResponse<Work>> workDetailById(int id) async {
    List<Map<String, dynamic>> work = await (await _getDatabase(true))
        .rawQuery("SELECT * FROM works WHERE id = ?", [id]);
    if (work != null && work.isNotEmpty) {
      return ApiResponse.ofSuccess(Work.fromDatabase(work[0]));
    } else {
      return ApiResponse.ofError(Exception(['找不到对应的作品']));
    }
  }

  ///查询作者名下的某个kind的作品
  Future<ApiResponse<List<Work>>> worksByAuthorAndKind(
      Author author, String kind) async {
    List<Map<String, dynamic>> work = await (await _getDatabase(true)).rawQuery(
        "SELECT * FROM works WHERE author_id = ? AND kind = ? ORDER BY id",
        [author.id, kind]);
    return ApiResponse.ofSuccess(
        work.map((item) => Work.fromDatabase(item)).toList());
  }
}
