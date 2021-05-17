import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maxsports/Constants/AppColors.dart';
import 'package:maxsports/Views/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConstants {
  static progress(bool isLoading, BuildContext context) {
    return isLoading
        ? Container(
            color: Colors.black38,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.black38,
              child: SpinKitThreeBounce(
                  size: 35,
                  duration: new Duration(milliseconds: 1800),
                  color: Colors.pink),
            ),
          )
        : Container();
  }

  showToast({String msg}) {
    // showToastWidget(Text('hello styled toast'));

    Fluttertoast.showToast(
        msg: "$msg",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.white10,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  showToast2({String msg, context}) {
    showToastWidget(
      Container(
        decoration: BoxDecoration(color: Colors.black54,borderRadius: BorderRadius.circular(10)),

        padding: const EdgeInsets.all(8.0),
        margin: EdgeInsets.only(bottom: 40),
        child: Text(
          '$msg',
        ),
      ),
      context: context,
      animation: StyledToastAnimation.none,
      reverseAnimation: StyledToastAnimation.slideFromBottomFade,
      position: StyledToastPosition.bottom,
      // animDuration: Duration(seconds: 1),
      // duration: Duration(seconds: 3),
      curve: Curves.fastLinearToSlowEaseIn,
      // reverseCurve: Curves.linear,
    );
  }

  void logout(context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false);
  }
}
