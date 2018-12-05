const String HOURLY = 'https://free-api.heweather.com/s6/weather/hourly';
const String FORECASE = 'https://free-api.heweather.com/s6/weather/forecast';
const String NOW = 'https://free-api.heweather.com/s6/weather/now';
const String LIFESTYLE = 'https://free-api.heweather.com/s6/weather/lifestyle';
const String WEATHER =
    'https://free-api.heweather.com/s6/weather?location=auto_ip&key=$KEY';

const String KEY = '60a16381a4024ee0a03dfa6d980def43';

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

  Daily.fromJSON(Map<String, dynamic> json)
      : dayCodeCond = int.parse(json['cond_code_d'].toString()),
        nightCodeCond = int.parse(json['cond_code_n'].toString()),
        dayCodeDesc = json['cond_txt_d'],
        nightCodeDesc = json['cond_txt_n'],
        date = json['date'],
        hum = int.parse(json['date'].toString()),
        pcpn = double.parse(json['pcpn'].toString()),
        pres = int.parse(json['pres'].toString()),
        maxTmp = int.parse(json['tmp_max'].toString()),
        minTmp = int.parse(json['tmp_min'].toString()),
        indexUv = int.parse(json['uv_index'].toString()),
        vis = int.parse(json['vis'].toString()),
        windDegree = int.parse(json['wind_deg'].toString()),
        windDir = json['wind_dir'],
        windSc = json['wind_sc'],
        pop = int.parse(json['wind_sc'].toString()),
        windSpeed = int.parse(json['wind_sc'].toString());
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
  final int pcpn;
  final int pres;
  final int tmp;
  final int vis;
  final int windDegree;
  final String windDir;
  final String windSc;
  final int windSpeed;

  Now.fromJSON(Map<String, dynamic> json)
      : condDesc = json['cond_txt'],
        condCode = int.parse(json['cond_txt'].toString()),
        fl = int.parse(json['fl'].toString()),
        hum = int.parse(json['hum'].toString()),
        pcpn = int.parse(json['pcpn'].toString()),
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
  WeatherReport.fail() {
    status = -1;
  }
  WeatherReport.loading() {
    status = 1;
  }

  WeatherReport.fromResponse(Map<String, dynamic> rsp) {
    basic = WeatherBasic.fromJSON(rsp['basic']);
    now = Now.fromJSON(rsp['now']);
    update = Update.fromJSON(rsp['update']);

    List daily = rsp['daily_forecast'];
    dailyReports = daily.map((m) => Daily.fromJSON(m)).toList();
    List hour = rsp['hourly'];
    hourlyReports = hour.map((m) => Hourly.fromJSON(m)).toList();
    List life = rsp['lifestyle'];
    lifestyles = life.map((m) => Lifestyle.fromJSON(m)).toList();
  }
}
