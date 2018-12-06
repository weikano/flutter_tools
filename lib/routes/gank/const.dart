const HOST = "http://gank.io/api";
//最新一天的干货
const TODAY = '$HOST/today';
//闲读的主分类
const XIANDU_CATEGORY = '$HOST/xiandu/categories';
//闲读的子分类，category后面接收的参数为主分类返回的en_name
const XIANDU_CHILD = '$HOST/xiandu/category/wow';
//闲读的详细数据, id为闲读子分类id；page为第几页，从1开始；count为每页的个数
const XIANDU_DATA = "$HOST/xiandu/data/id/appinn/count/10/page1";
//搜索category后面接收参数all|Android|iOS|休息视频|福利|前端|瞎推荐|App；count最大为50
const SEARCH = '$HOST/search/query/listview/category/Android/count/10/page/1';
//获取某几日干货网站数据, 2代表2个数据，1代表取第一页数据
const HISTORY = '$HOST/history/content/2/1';
const HISTORY_SPECIFIC = '$HOST/history/content/day/2016/05/11';
//获取发过干货日期接口
const DAY_HISTORY = '$HOST/day/history';
//每日数据
const DAILY = '$HOST/day/2015/08/06';
//随机数据
const RANDOM = '$HOST/random/data/Android/20';
