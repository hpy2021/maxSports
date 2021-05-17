class TimeZoneResponse {
  List<TimeZoneData> timeZoneData;

  TimeZoneResponse({this.timeZoneData});

  TimeZoneResponse.fromJson(Map<String, dynamic> json) {
    if (json['res_data'] != null) {
      timeZoneData = new List<TimeZoneData>();
      json['res_data'].forEach((v) {
        timeZoneData.add(new TimeZoneData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.timeZoneData != null) {
      data['res_data'] = this.timeZoneData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TimeZoneData {
  String tzId;
  String timezone;

  TimeZoneData({this.tzId, this.timezone});

  TimeZoneData.fromJson(Map<String, dynamic> json) {
    tzId = json['tz_id'];
    timezone = json['timezone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tz_id'] = this.tzId;
    data['timezone'] = this.timezone;
    return data;
  }
}
