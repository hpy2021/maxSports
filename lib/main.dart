import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maxsports/Constants/AppColors.dart';
import 'package:maxsports/Providers/LoginProvider.dart';
import 'package:maxsports/Providers/LiveShowProvider.dart';
import 'package:maxsports/Views/login_screen.dart';
import 'package:maxsports/Views/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() {
  tz.initializeTimeZones();
  runApp(

    MultiProvider(
    providers: providers,
    child: MyApp(),
  ),);
}
List<SingleChildWidget> providers = [
  ChangeNotifierProvider<LoginProvider>(create: (_) => LoginProvider()),
  ChangeNotifierProvider<LiveShowProvider>(create: (_) =>LiveShowProvider())
];
class MyApp extends StatelessWidget {
  @override
  MaterialColor customAppColor = MaterialColor(0xff008840, AppColors().color);
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'MaxSports',
      debugShowCheckedModeBanner: false,
      theme:ThemeData(
        brightness: Brightness.dark,
      primarySwatch: customAppColor,
        fontFamily: "OpenSans"
      ),
      home: SplashScreen(),

    );
  }

  // Widget goToLoginorHome()async {
  //   try {
  //     prefs = await SharedPreferences.getInstance();
  //     if(prefs.getString(AppStrings.TOKEN_KEY) != null){
  //       _home();
  //       // _login();
  //
  //     } else {
  //       _login();
  //     }
  //
  //   } catch (E) {}
  //
  // }

  _iosApp(){
    return CupertinoApp(
      title: 'MaxSports',
      debugShowCheckedModeBanner: false,
theme: CupertinoThemeData(
  textTheme:CupertinoTextThemeData(
    textStyle: TextStyle(fontFamily: "Open Sans")
  ) ,
),
      home: SplashScreen(),


    );
  }
  _androidApp(){
    return MaterialApp(
      title: 'MaxSports',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}

