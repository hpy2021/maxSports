class CommonResponse {
  bool result;
  String msg;

  CommonResponse({this.result, this.msg});

  CommonResponse.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['msg'] = this.msg;
    return data;
  }
}
