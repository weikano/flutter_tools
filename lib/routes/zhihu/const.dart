import 'package:flutter_tools/converter/json_converter.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

//启动界面图像
const LAUNCH_IMAGE =
    'https://news-at.zhihu.com/api/7/fetch-launch-images/1080*1920';
const NEWS = 'https://news-at.zhihu.com/api/4/news/latest';
const CONTENT = 'https://news-at.zhihu.com/api/4/news';

///before后面的参数为日期，比如要查询20131118，则数字为20131119
const BEFORE = 'https://news-at.zhihu.com/api/4/news/before/20131119';

///查询额外的信息，比如长评论/段评论的个数, popularity(赞数)，评论个数等
const EXTRA = 'https://news-at.zhihu.com/api/4/story-extra';

///story后面的参数为id
const LONG = 'https://news-at.zhihu.com/api/4/story/8997528/long-comments';

///story后面的参数为id
const SHORT = 'https://news-at.zhihu.com/api/4/story/4232852/short-comments';

abstract class ZhihuStoryBase {
  String get title;

  int get id;

  int get type;
}

///列表展示的内容
class ZhihuListItem extends ZhihuStoryBase {
  List<String> images;
  String title;
  int type;
  int id;
  String date;

  ZhihuListItem.fromJSON(Map<String, dynamic> json) {
    title = optJSON(json, 'title');
    type = optJSON(json, 'type');
    id = optJSON(json, 'id');
    List list = optJSON(json, 'images');
    images = list?.map((m) => m.toString())?.toList();
  }
}

///首页最上面的PageView展示的内容
class ZhihuTopItem extends ZhihuStoryBase {
  String title;
  String image;
  int type;
  int id;

  ZhihuTopItem.fromJSON(Map<String, dynamic> json) {
    title = optJSON(json, 'title');
    image = optJSON(json, 'image');
    type = optJSON(json, 'type');
    id = optJSON(json, 'id');
  }

  List<dynamic> toValues() {
    return <dynamic>[id, type, image, title];
  }
}

///通过news接口获取到的内容
class ZhihuNews {
  String date;
  List<ZhihuListItem> stories;
  List<ZhihuTopItem> topStories;

  ZhihuNews.fromJSON(Map<String, dynamic> json) {
    date = optJSON(json, 'date');
    List list = optJSON(json, 'stories');
    stories = list?.map((m) => ZhihuListItem.fromJSON(m))?.toList();
    stories.forEach((item) {
      item.date = date;
    });
    list = optJSON(json, 'top_stories');
    topStories = list?.map((m) => ZhihuTopItem.fromJSON(m))?.toList();
  }
}

///知乎内容类型
enum ZhihuParaType {
  pic,
  text,
  author,
}

///知乎内容段落
class ZhihuStoryPara {
  ZhihuParaType type;
  String content;

  ZhihuStoryPara.image(String url) {
    type = ZhihuParaType.pic;
    content = url;
  }

  ZhihuStoryPara.text(String text) {
    type = ZhihuParaType.text;
    content = text;
  }

  ZhihuStoryPara.author() {
    type = ZhihuParaType.author;
  }
}

///由body解析后的知乎内容
class ZhihuStoryDetail {
  String questionTitle; //h2 class=question-title
  String avatar; //img class=avatar
  String author; //span class=author
  String bio = ''; //span class=bio

  List<ZhihuStoryPara> ps = <ZhihuStoryPara>[];

  ZhihuStoryDetail.fromDocument(Document document) {
    List<ZhihuStoryPara> header = <ZhihuStoryPara>[];
    List<ZhihuStoryPara> after = <ZhihuStoryPara>[];
    questionTitle = document.getElementsByClassName('question-title')[0].text;
    print(questionTitle);
    avatar = document.getElementsByClassName('avatar')[0].attributes['src'];
    print(avatar);
    author = document.getElementsByClassName('author')[0].text;
    print(author);
    var bioElements = document.getElementsByClassName('bio');
    if (bioElements.isNotEmpty) {
      bio = bioElements[0].text;
    }
    print(bio);

    //获取class=question节点
    List<Element> questions = document.getElementsByClassName('question');
    for (Element question in questions) {
      if (question.getElementsByClassName('avatar').isNotEmpty) {
        //添加至ps中
        after.addAll(_paraItems(question));
      } else {
        //添加至header中
        header.addAll(_headerItems(question));
      }
    }
    //添加before
    ps.addAll(header);
    //添加作者信息
    ps.add(ZhihuStoryPara.author());
    //添加after
    ps.addAll(after);
  }

  List<ZhihuStoryPara> _headerItems(Element document) {
    Element raw = document.getElementsByClassName('content')[0];
    var paras = raw.getElementsByTagName('p');
    return paras.map((para) {
      var images = para.getElementsByTagName('img');
      if (images != null && images.isNotEmpty) {
        return ZhihuStoryPara.image(images[0].attributes['src']);
      } else {
        return ZhihuStoryPara.text(para.text);
      }
    }).toList();
  }

  List<ZhihuStoryPara> _paraItems(Element document) {
    Element raw = document.getElementsByClassName('content')[0];
    var paras = raw.getElementsByTagName('p');
    return paras.map((para) {
      var images = para.getElementsByClassName('content-image');
      if (images != null && images.isNotEmpty) {
        return ZhihuStoryPara.image(images[0].attributes['src']);
      } else {
        return ZhihuStoryPara.text(para.text);
      }
    }).toList();
  }
}

///通过CONTENT接口请求到的内容
class ZhihuStory {
  String body;
  String imageSource;
  String title;
  String image;
  String shareUrl;
  List<String> js;
  List<String> images;
  int type;
  int id;
  List<String> css;
  ZhihuStoryDetail parsed;

  ZhihuStory.fromJSON(Map<String, dynamic> json) {
    body = optJSON(json, 'body');
    imageSource = optJSON(json, 'image_source');
    image = optJSON(json, 'image');
    title = optJSON(json, 'title');
    shareUrl = optJSON(json, 'share_url');
    print('SHAREURL ${shareUrl}');
    List list = optJSON(json, 'js');
    js = list?.map((m) => m.toString())?.toList();
    list = optJSON(json, 'images');
    images = list?.map((m) => m.toString())?.toList();
    type = optJSON(json, 'type');
    id = optJSON(json, 'id');
    list = optJSON(json, 'css');
    css = list?.map((m) => m.toString())?.toList();

    var document = parse(body);
    parsed = ZhihuStoryDetail.fromDocument(document);
  }
}

///通过EXTRA接口获取到的信息
class ZhihuStoryExtra {
  int long;
  int short;
  int popularity;
  int total;

  ZhihuStoryExtra.fromJSON(Map<String, dynamic> json) {
    long = optJSON(json, 'long_comments');
    short = optJSON(json, 'short_comments');
    popularity = optJSON(json, 'popularity');
    total = optJSON(json, 'comments');
  }
}

class ZhihuCommentReplyTo {
  String author;
  String content;
  int status;
  int id;
  String errMsg;

  ZhihuCommentReplyTo.fromJSON(Map<String, dynamic> json) {
    author = optJSON(json, 'author');
    content = optJSON(json, 'content');
    status = optJSON(json, 'status');
    id = optJSON(json, 'id');
    errMsg = optJSON(json, 'error_msg');
  }
}

enum ZhihuCommentType {
  short,
  long,
}

class ZhihuComment {
  ZhihuCommentType type;
  String author;
  String content;
  String avatar;
  int id;
  int likes;
  DateTime time;
  ZhihuCommentReplyTo replyTo;

  ZhihuComment.fromJSON(Map<String, dynamic> json) {
    author = optJSON(json, 'author');
    content = optJSON(json, 'content');
    avatar = optJSON(json, 'avatar');
    id = optJSON(json, 'id');
    likes = optJSON(json, 'likes');
    time = DateTime.fromMillisecondsSinceEpoch(optJSON(json, 'time') * 1000);
    var replyToRaw = optJSON(json, 'reply_to');
    if (replyToRaw != null) {
      replyTo = ZhihuCommentReplyTo.fromJSON(replyToRaw);
    }
  }
}
