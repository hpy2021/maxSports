import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:maxsports/Constants/ApiManager.dart';
import 'package:maxsports/Constants/AppStrings.dart';
import 'package:maxsports/Models/CommonResponse.dart';
import 'package:maxsports/Models/LiveShowResponse.dart';
import 'package:maxsports/Models/TimeZoneResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LiveShowProvider extends ChangeNotifier {
  bool isLoading = true;
  SharedPreferences sharedPreferences;
  BuildContext context;
  void setContext(BuildContext context) {
    this.context = context;
  }

  LiveShowResponse _liveDataResponse = new LiveShowResponse();
  List<ResData> list = [];

  LiveShowProvider() {
    _liveDataResponse.resData = list;
  }

  void setData(LiveShowResponse data) {
    this._liveDataResponse = data;
    isLoading = false;
    notifyListeners();
  }

  LiveShowResponse getData() {
    return _liveDataResponse;
  }

  Future<LiveShowResponse> getLiveShow() async {
    try {
      isLoading = true;
      sharedPreferences = await SharedPreferences.getInstance();
      var token = sharedPreferences.getString(AppStrings.TOKEN_KEY);
      var request = Map<String, String>();
      request["token"] = token;
      print(request);
      // LoginResponse response = LoginResponse.fromJson(await ApiManager().getCall(AppStrings.loginUrl+"?data={u_pin:4595}"));
      LiveShowResponse response = LiveShowResponse.fromJson(
        await ApiManager().getCallwithheader(
            AppStrings.getLiveShows + "?data=" + json.encode(request), context),
      );
      // print(response.msg);
      if (response != null) {
        isLoading = false;
        return response;
      } else {
        isLoading = false;
        return null;
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<CommonResponse> updateShowDetail(
      {String id,
      String title,
      String date,
      String time,
      String customMsg,
      String timeZone}) async {

    try {
      isLoading = true;

      print("in tthe api $timeZone");
      sharedPreferences = await SharedPreferences.getInstance();
      var token = sharedPreferences.getString(AppStrings.TOKEN_KEY);
      var request = Map<String, String>();
      request["gameId"] = id;
      request["title"] = title;
      request["date"] = date;
      request["time"] = time;
      request["isLiveStream"] = "true";
      request["customMsg"] = customMsg;
      request["timezone"] = timeZone;
      request["token"] = token;
      print(request);
      // LoginResponse response = LoginResponse.fromJson(await ApiManager().getCall(AppStrings.loginUrl+"?data={u_pin:4595}"));
      CommonResponse response = CommonResponse.fromJson(
        await ApiManager().getCallwithheader(
            AppStrings.updateShowDetail + "?data=" + json.encode(request),
            context),
      );
      print(response.msg);
      if (response.msg == "true") {
        isLoading = false;

        return response;
      } else {
        isLoading = false;
        return response;
      }


    } catch (e) {
      print(e);
    }
    notifyListeners();

  }

  Future<CommonResponse> makestreamlive({@required String id}) async {
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      var token = sharedPreferences.getString(AppStrings.TOKEN_KEY);
      isLoading = true;
      var request = Map<String, String>();
      request["gameId"] = id;
      request["token"] = token;
      print(request);
      // LoginResponse response = LoginResponse.fromJson(await ApiManager().getCall(AppStrings.loginUrl+"?data={u_pin:4595}"));
      CommonResponse response = CommonResponse.fromJson(
        await ApiManager().getCallwithheader(
            AppStrings.makeStreamLive + "?data=" + json.encode(request),
            context),
      );
      print(response.msg);
      if (response.msg == "true") {
        isLoading = false;

        return response;
      } else {
        isLoading = false;
        return response;
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<CommonResponse> stopLiveStream({String id}) async {
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      String token = sharedPreferences.getString(AppStrings.TOKEN_KEY);

      var request = new HashMap();
      request["gameId"] = id;
      request["token"] = token;
      CommonResponse response = CommonResponse.fromJson(await ApiManager()
          .getCallwithheader(
              AppStrings.stopLiveStream + "?data=" + json.encode(request),
              context));
      print(response.msg);
      if (response.msg == "true") {
        isLoading = false;

        return response;
      } else {
        isLoading = false;
        return response;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<CommonResponse> changePin({String pin}) async {
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      String token = sharedPreferences.getString(AppStrings.TOKEN_KEY);

      var request = new HashMap();
      request["pin"] = pin;
      request["token"] = token;
      CommonResponse response = CommonResponse.fromJson(
        await ApiManager().getCallwithheader(
            AppStrings.changePinUrl + "?data=" + json.encode(request), context),
      );
      print(response.msg);
      if (response.msg == "true") {
        isLoading = false;
        return response;
      } else {
        isLoading = false;
        return response;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<TimeZoneResponse> getTimezone() async {
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      String token = sharedPreferences.getString(AppStrings.TOKEN_KEY);

      var request = new HashMap();

      TimeZoneResponse response = TimeZoneResponse.fromJson(
        await ApiManager().getCallwithheader(
            AppStrings.timeZoneUrl + "?data=" , context),
      );
      print(response.timeZoneData.length);
      if (response.timeZoneData.length != 0) {
        isLoading = false;
        return response;
      } else {
        isLoading = false;
        return response;
      }
    } catch (e) {
      print(e);
    }
  }


  Future<ResData> getLiveShowData({String id}) async {
    try {
      isLoading = true;
      sharedPreferences = await SharedPreferences.getInstance();
      var token = sharedPreferences.getString(AppStrings.TOKEN_KEY);
      var request = Map<String, String>();
      request["id"] = id;
      request["token"] = token;
      print(request);
      // LoginResponse response = LoginResponse.fromJson(await ApiManager().getCall(AppStrings.loginUrl+"?data={u_pin:4595}"));
      ResData response = ResData.fromJson(
        await ApiManager().getCallwithheader(
            AppStrings.getliveShowData + "?data=" + json.encode(request), context),
      );
      // print(response.msg);
      if (response != null) {
        isLoading = false;
        return response;
      } else {
        isLoading = false;
        return null;
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }
}
