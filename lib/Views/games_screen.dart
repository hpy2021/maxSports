import 'package:flutter/material.dart';
import 'package:maxsports/Constants/AppColors.dart';

class GamesScreen extends StatefulWidget {
  @override
  _GamesScreenState createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:AppColors.backGroundColor,body: Center(child: Padding(
      padding: const EdgeInsets.all(30.0),
      child: Container(
        child: Image.asset("assets/images/comingSoon.png",fit: BoxFit.contain,),
      ),
    ),
    ),);
  }
}


