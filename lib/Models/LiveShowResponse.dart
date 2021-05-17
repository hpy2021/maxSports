class LiveShowResponse {
  List<ResData> resData;

  LiveShowResponse({this.resData});

  LiveShowResponse.fromJson(Map<String, dynamic> json) {
    if (json['res_data'] != null) {
      resData = new List<ResData>();
      json['res_data'].forEach((v) {
        resData.add(new ResData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.resData != null) {
      data['res_data'] = this.resData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ResData {
  String id;
  String title;
  String thumbURL;
  String videoURL;
  String categories;
  String displayOrder;
  String isLive;
  String date;
  String time;
  String timzone;

  ResData(
      {this.id,
        this.title,
        this.thumbURL,
        this.videoURL,
        this.categories,
        this.displayOrder,
        this.isLive,
        this.date,
        this.time,
        this.timzone});

  ResData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    thumbURL = json['thumbURL'];
    videoURL = json['videoURL'];
    categories = json['categories'];
    displayOrder = json['displayOrder'];
    isLive = json['isLive'];
    date = json['date'];
    time = json['time'];
    timzone = json['timzone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['thumbURL'] = this.thumbURL;
    data['videoURL'] = this.videoURL;
    data['categories'] = this.categories;
    data['displayOrder'] = this.displayOrder;
    data['isLive'] = this.isLive;
    data['date'] = this.date;
    data['time'] = this.time;
    data['timzone'] = this.timzone;
    return data;
  }
}
