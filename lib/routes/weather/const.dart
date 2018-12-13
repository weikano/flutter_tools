const String HOURLY = 'https://free-api.heweather.com/s6/weather/hourly';
const String FORECAST = 'https://free-api.heweather.com/s6/weather/forecast';
const String NOW =
    'https://free-api.heweather.com/s6/weather/now?localtion=auto_ip&key=$KEY';
const String LIFESTYLE = 'https://free-api.heweather.com/s6/weather/lifestyle';
const String WEATHER =
    'https://free-api.heweather.com/s6/weather?location=auto_ip&key=$KEY';

const String KEY = '60a16381a4024ee0a03dfa6d980def43';

const Map<String, String> LIFESTYLES = <String, String>{
  'spi': '防晒指数',
  'fsh': '钓鱼指数',
  'ptfc': '交通指数',
  'airc': '晾晒指数',
  'mu': '化妆指数',
  'gl': '太阳镜指数',
  'ag': '过敏指数',
  'ac': '空调开启指数',
  'air': '空气污染扩散条件指数',
  'uv': '紫外线指数',
  'trav': '旅游指数',
  'sport': '运动指数',
  'flu': '感冒指数',
  'drsg': '穿衣指数',
  'cw': '洗车指数',
  'comf': '舒适度指数',
};

class WeatherBasic {
  final String cid;
  final String location;
  final String pcity;
  final String country;
  final double lat;
  final double lon;
  final double timezone;

  WeatherBasic(
      {this.cid,
      this.location,
      this.pcity,
      this.country,
      this.lat,
      this.lon,
      this.timezone});

  WeatherBasic.fromJSON(Map<String, dynamic> json)
      : cid = json['cid'],
        location = json['location'],
        pcity = json['parent_city'],
        country = json['cnty'],
        lat = double.parse(json['lat'].toString()),
        lon = double.parse(json['lon'].toString()),
        timezone = double.parse(json['tz'].toString());
}

class Daily {
  final int dayCodeCond;
  final int nightCodeCond;
  final String dayCodeDesc;
  final String nightCodeDesc;
  final String date;
  final int hum;
  final double pcpn;
  final int pop;
  final int pres;
  final int maxTmp;
  final int minTmp;
  final int indexUv;
  final int vis;
  final int windDegree;
  final String windDir;
  final String windSc;
  final int windSpeed;
  final String sr;
  final String ss;
  final String mr;
  final String ms;

  Daily.fromJSON(Map<String, dynamic> json)
      : dayCodeCond = int.parse(json['cond_code_d'].toString()),
        nightCodeCond = int.parse(json['cond_code_n'].toString()),
        dayCodeDesc = json['cond_txt_d'],
        nightCodeDesc = json['cond_txt_n'],
        date = json['date'],
        hum = int.parse(json['hum'].toString()),
        pcpn = double.parse(json['pcpn'].toString()),
        pres = int.parse(json['pres'].toString()),
        maxTmp = int.parse(json['tmp_max'].toString()),
        minTmp = int.parse(json['tmp_min'].toString()),
        indexUv = int.parse(json['uv_index'].toString()),
        vis = int.parse(json['vis'].toString()),
        windDegree = int.parse(json['wind_deg'].toString()),
        windDir = json['wind_dir'],
        windSc = json['wind_sc'],
        pop = int.parse(json['pop'].toString()),
        sr = json['sr'],
        ss = json['ss'],
        mr = json['mr'],
        ms = json['ms'],
        windSpeed = int.parse(json['wind_spd'].toString());
}

class Hourly {
  final int cloud;
  final int condCode;
  final int condDesc;
  final int hum;
  final int pop;
  final int pres;
  final String time;
  final int tmp;
  final int windDegree;
  final String windDir;
  final String windSc;
  final int windSpeed;

  Hourly.fromJSON(Map<String, dynamic> json)
      : cloud = int.parse(json['cloud'].toString()),
        condCode = int.parse(json['cond_code'].toString()),
        hum = int.parse(json['hum'].toString()),
        pop = int.parse(json['pop'].toString()),
        pres = int.parse(json['pres'].toString()),
        tmp = int.parse(json['tmp'].toString()),
        windDegree = int.parse(json['wind_deg'].toString()),
        windSpeed = int.parse(json['wind_spd'].toString()),
        condDesc = json['cond_txt'],
        windDir = json['wind_dir'],
        windSc = json['wind_dir'],
        time = json['time'];
}

class Lifestyle {
  final String brief;
  final String desc;
  final String type;

  Lifestyle.fromJSON(Map<String, dynamic> json)
      : brief = json['brf'],
        desc = json['txt'],
        type = json['type'];
}

class Now {
  final int condCode;
  final String condDesc;
  final int fl;
  final int hum;
  final double pcpn;
  final int pres;
  final int tmp;
  final int vis;
  final int windDegree;
  final String windDir;
  final String windSc;
  final int windSpeed;

  Now.fromJSON(Map<String, dynamic> json)
      : condDesc = json['cond_txt'],
        condCode = int.parse(json['cond_code'].toString()),
        fl = int.parse(json['fl'].toString()),
        hum = int.parse(json['hum'].toString()),
        pcpn = double.parse(json['pcpn'].toString()),
        pres = int.parse(json['pres'].toString()),
        tmp = int.parse(json['tmp'].toString()),
        vis = int.parse(json['vis'].toString()),
        windDegree = int.parse(json['wind_deg'].toString()),
        windSpeed = int.parse(json['wind_spd'].toString()),
        windDir = json['wind_dir'],
        windSc = json['wind_sc'];
}

class Update {
  final String loc;
  final String utc;

  Update.fromJSON(Map<String, dynamic> json)
      : loc = json['loc'],
        utc = json['utc'];
}

class WeatherReport {
  int status = 0;
  WeatherBasic basic;
  List<Daily> dailyReports;
  List<Hourly> hourlyReports;
  List<Lifestyle> lifestyles;
  Now now;
  Update update;

  WeatherReport(
      {this.basic,
      this.dailyReports,
      this.hourlyReports,
      this.lifestyles,
      this.now,
      this.update});

  WeatherReport.ofFail() {
    status = -1;
  }

  WeatherReport.ofLoading() {
    status = 1;
  }

  bool loading() {
    return status == 1;
  }

  bool success() {
    return status == 0;
  }

  bool fail() {
    return status == -1;
  }

  WeatherReport.ofSuccess(Map<String, dynamic> rsp) {
    if (rsp.containsKey('basic')) {
      basic = WeatherBasic.fromJSON(rsp['basic']);
    }
    if (rsp.containsKey('now')) {
      now = Now.fromJSON(rsp['now']);
    }
    if (rsp.containsKey('update')) {
      update = Update.fromJSON(rsp['update']);
    }
    if (rsp.containsKey('daily_forecast')) {
      List daily = rsp['daily_forecast'];
      dailyReports = daily.map((m) => Daily.fromJSON(m)).toList();
    }
    if (rsp.containsKey('hourly')) {
      List hour = rsp['hourly'];
      hourlyReports = hour.map((m) => Hourly.fromJSON(m)).toList();
    }
    if (rsp.containsKey('lifestyle')) {
      List life = rsp['lifestyle'];
      lifestyles = life.map((m) => Lifestyle.fromJSON(m)).toList();
    }
  }
}

class WeatherStatus {
  final String label;
  final String icon;
  WeatherStatus(this.label, this.icon);
}

Map<int, WeatherStatus> weatherStatus = _initWeatherStatus();
Map<int, WeatherStatus> _initWeatherStatus() {
  //todo not finished
  return <int, WeatherStatus>{
    100: WeatherStatus('晴', '100.png'),
    101: WeatherStatus('多云', '101.png'),
    102: WeatherStatus('少云', '102.png'),
    103: WeatherStatus('晴间多云', '103.png'),
    104: WeatherStatus('阴', '104.png'),
    200: WeatherStatus('有风', '200.png'),
  };
}
