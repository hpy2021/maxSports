import 'package:flutter/material.dart';
import 'package:maxsports/Constants/AppColors.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Container(
            child: Image.asset("assets/images/comingSoon.png",fit: BoxFit.contain,),
          ),
        ),
      ),
    );
  }
}
