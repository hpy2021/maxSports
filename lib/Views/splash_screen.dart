import 'package:flutter/material.dart';
import 'package:maxsports/Constants/AppColors.dart';
import 'package:maxsports/Constants/AppStrings.dart';
import 'package:maxsports/Views/bottom_nav_bar.dart';
import 'package:maxsports/Views/shows_screen.dart';
import 'package:maxsports/Views/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SharedPreferences prefs;

  void navigate() {
    Future.delayed(const Duration(milliseconds: 3000), () async {
      try {
        prefs = await SharedPreferences.getInstance();
        if (prefs.getString(AppStrings.TOKEN_KEY) != null) {
          _home();
        } else {
          _login();
        }
      } catch (E) {}
    });
  }

  _login() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }

  _home() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => BottomNavigationBarView(
            selectedIndex: 2,
          ),
        ),
        (route) => false);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    navigate();
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
      // padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xffF8FDFF),
                Color(0xffDCFEFD)
              ],
                  begin: Alignment.topLeft,
              end: Alignment.bottomRight
            )
          ),
          height: MediaQuery.of(context).size.height,

          child: Image.asset(
      "assets/images/logo2.jpg",
            fit: BoxFit.cover,

    ),
        );
  }
}
