import 'package:flutter/material.dart';
import 'package:maxsports/Constants/AppColors.dart';

class BackgroundCurvedView extends StatelessWidget {
  Widget widget;
  BackgroundCurvedView({@required this.widget});
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height:double.infinity,
        decoration: BoxDecoration(
          color: AppColors.backGroundColor,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft: Radius.circular(30),
            ),
            child: widget));
  }
}
