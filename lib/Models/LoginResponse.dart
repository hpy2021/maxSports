class LoginResponse {
  String msg;
  String token;

  LoginResponse({this.msg, this.token});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['token'] = this.token;
    return data;
  }
}
