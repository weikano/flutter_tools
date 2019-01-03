import 'package:flutter_tools/converter/json_converter.dart';

///作者
class Author {
  final int id;
  final String name;
  final String intro;
  final int countOfQuotes;
  final int countOfViews;
  final String dynasty;
  final String yearOfBirth;
  final String yearOfDeath;
  final String updatedAt;
  final String wiki;
  final int countOfWorks;
  final int countOfShi;
  final int countOfCi;
  final int countOfWen;
  final int countOfQu;
  final int countOfFu;

  Author.fromDatabase(Map<String, dynamic> item)
      : id = optJSON(item, "id"),
        name = optJSON(item, "name"),
        intro = optJSON(item, "intro"),
        countOfQuotes = optJSON(item, "quotes_count"),
        countOfViews = optJSON(item, "views_count"),
        dynasty = optJSON(item, "dynasty"),
        yearOfBirth = optJSON(item, "birth_year"),
        yearOfDeath = optJSON(item, "death_year"),
        updatedAt = optJSON(item, "updated_at"),
        wiki = optJSON(item, "baidu_wiki"),
        countOfWorks = optJSON(item, "works_count"),
        countOfShi = optJSON(item, "works_shi_count"),
        countOfCi = optJSON(item, "works_ci_count"),
        countOfWen = optJSON(item, "works_wen_count"),
        countOfQu = optJSON(item, "works_qu_count"),
        countOfFu = optJSON(item, "works_fu_count");
}

///c朝代
class Dynasty {
  final int id;
  final String name;
  final String intro;
  final String startYear;
  final String endYear;
  final String nameTr;
  final String introTr;

  Dynasty.fromDatabase(Map<String, dynamic> item)
      : id = optJSON(item, "id"),
        name = optJSON(item, "name"),
        intro = optJSON(item, "intro"),
        startYear = optJSON(item, "start_year"),
        endYear = optJSON(item, "end_year"),
        nameTr = optJSON(item, "name_tr"),
        introTr = optJSON(item, "intro_tr");
  Dynasty.simple(String name)
      : id = -1,
        name = name,
        intro = '',
        startYear = '',
        endYear = '',
        nameTr = '',
        introTr = '';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Dynasty &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}

class PoetTheme {
  final int id;
  final int show_order;
  final String name;
  final String name_tr;

  PoetTheme.fromDatabase(Map<String, dynamic> item)
      : id = optJSON(item, "id"),
        show_order = optJSON(item, "show_order"),
        name = optJSON(item, "name"),
        name_tr = optJSON(item, "name_tr");

  PoetTheme.simple(int id, String name)
      : id = id,
        name = name,
        show_order = 0,
        name_tr = "";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PoetTheme && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

///作品
class Work {
  final int id;
  final String title;
  final int posts_count;
  final int quotes_count;
  final int collections_count;
  final String author;
  final int authorId;
  final String dynasty;
  final String kind;
  final String kind_cn;
  final String wiki;
  final String foreword;
  final String content;
  final String intro;
  final String annotation;
  final String translation;
  final String appreciation;
  final String master_comment;
  final String layout;

  Work.fromDatabase(Map<String, dynamic> item)
      : id = optJSON(item, "id"),
        title = optJSON(item, "title"),
        posts_count = optJSON(item, "posts_count"),
        quotes_count = optJSON(item, "quotes_count"),
        collections_count = optJSON(item, "collections_count"),
        author = optJSON(item, "author"),
        authorId = optJSON(item, "authorId"),
        dynasty = optJSON(item, "dynasty"),
        kind = optJSON(item, "kind"),
        kind_cn = optJSON(item, "kind_cn"),
        wiki = optJSON(item, "baidu_wiki"),
        foreword = optJSON(item, "foreword"),
        content = optJSON(item, "content"),
        intro = optJSON(item, "intro"),
        annotation = optJSON(item, "annotation"),
        translation = optJSON(item, "translation"),
        appreciation = optJSON(item, "appreciation"),
        master_comment = optJSON(item, "master_comment"),
        layout = optJSON(item, "layout");

  bool center() {
    return layout == 'center';
  }
}

class Collection {
  final int id;
  final int order;
  final int works_count;
  final String name;
  final String short_desc;
  final String desc;
  final String cover;
  final int kind_id;
  final String kind;
  final int quotes_count;
  final String name_tr;
  final String short_desc_tr;
  final String desc_tr;
  final String kind_tr;

  Collection.fromDatabase(Map<String, dynamic> item)
      : id = optJSON(item, "id"),
        order = optJSON(item, "show_order"),
        works_count = optJSON(item, "works_count"),
        name = optJSON(item, "name"),
        short_desc = optJSON(item, "short_desc"),
        desc = optJSON(item, "desc"),
        cover = optJSON(item, "cover"),
        kind_id = optJSON(item, "kind_id"),
        kind = optJSON(item, "kind"),
        quotes_count = optJSON(item, "quotes_count"),
        name_tr = optJSON(item, "name_tr"),
        short_desc_tr = optJSON(item, "short_desc_tr"),
        desc_tr = optJSON(item, "desc_tr"),
        kind_tr = optJSON(item, "kind_tr");
}

///点击作品集后显示的摘录
class CollectionQuote {
  final int quote_id;
  final String quote;
  final String quote_work;
  final String quote_author;

  CollectionQuote.fromDatabase(Map<String, dynamic> item)
      : quote_id = optJSON(item, 'quote_id'),
        quote = optJSON(item, 'quote'),
        quote_work = optJSON(item, 'quote_work'),
        quote_author = optJSON(item, 'quote_author');
}

class CollectionWork {
  final int id;
  final int show_order;
  final int work_id;
  final String work_title;
  final String work_author;
  final String work_dynasty;
  final String work_content;

  CollectionWork.fromDatabase(Map<String, dynamic> item)
      : id = optJSON(item, "id"),
        show_order = optJSON(item, "show_order"),
        work_id = optJSON(item, "work_id"),
        work_title = optJSON(item, "work_title"),
        work_author = optJSON(item, "work_author"),
        work_dynasty = optJSON(item, "work_dynasty"),
        work_content = optJSON(item, "work_content");
}
