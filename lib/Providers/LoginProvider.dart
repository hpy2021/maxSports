import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maxsports/Constants/ApiManager.dart';
import 'package:maxsports/Constants/AppStrings.dart';
import 'package:maxsports/Models/LoginResponse.dart';
import 'package:maxsports/Views/shows_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider extends ChangeNotifier {
  BuildContext context;
  bool isLoading = false;
  SharedPreferences sharedPreferences;

  LoginProvider();

  void setContext(BuildContext context) {
    this.context = context;
  }

  Future<LoginResponse> login({String pin , String email}) async {
    try {
      isLoading = true;
      var request = Map<String, String>();
      request["email"] = "$email";
      request["u_pin"] = pin;
      print(request);
      // LoginResponse response = LoginResponse.fromJson(await ApiManager().getCall(AppStrings.loginUrl+"?data={u_pin:4595}"));
      LoginResponse response = LoginResponse.fromJson(
        await ApiManager().getCall(
          AppStrings.loginUrl + "?data=" + json.encode(request),
        ),
      );
      print(response.msg);
      if (response.msg == "true") {
        isLoading = false;
        sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.setString(AppStrings.TOKEN_KEY, response.token);
        await sharedPreferences.setString(AppStrings.LOGIN_EMAIL, email);

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

}
