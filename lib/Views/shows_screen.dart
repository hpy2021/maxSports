import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:maxsports/Constants/ApiManager.dart';
import 'package:maxsports/Constants/AppColors.dart';
import 'package:maxsports/Constants/AppConstants.dart';
import 'package:maxsports/Constants/AppStrings.dart';
import 'package:maxsports/Models/LiveShowResponse.dart';
import 'package:maxsports/Models/LoginResponse.dart';
import 'package:maxsports/Providers/LiveShowProvider.dart';
import 'package:maxsports/Views/details_screen.dart';
import 'package:maxsports/Views/start_show_screen.dart';
import 'package:maxsports/Views/update_show_screen.dart';
import 'package:maxsports/Widgets/back_ground_view.dart';
import 'package:maxsports/Widgets/video_player.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class ShowsScreen extends StatefulWidget {
  @override
  _ShowsScreenState createState() => _ShowsScreenState();
}

class _ShowsScreenState extends State<ShowsScreen> {
  apicall() async {
    if(mounted)
      setState(() {
        isLoading = true;
      });
    Provider.of<LiveShowProvider>(context,listen: false).setContext(context);
    LiveShowResponse data =
        await Provider.of<LiveShowProvider>(context, listen: false)
            .getLiveShow();
    Provider.of<LiveShowProvider>(context, listen: false).setData(data);
    if(mounted)
      setState(() {
        isLoading = false;
      });
  }

  SharedPreferences sharedPreferences;
  bool isLoading = false;
  var list;
  CountdownTimerController controller;
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 40;
  DateTime dateTimeCreatedAt;

  DateTime dateTimeNow = DateTime.now();
  int remaininHours = 0;

  bool isFirst = false;

  void onEnd() {
    print('onEnd');
  }

  getTimerTime(ResData resData) {
    dateTimeCreatedAt = DateTime.parse('${resData.date} ${resData.time}');
    int data = dateTimeCreatedAt.millisecondsSinceEpoch;

    final differenceInDays = dateTimeCreatedAt.difference(dateTimeNow).inHours;
    remaininHours = dateTimeCreatedAt.difference(dateTimeNow).inHours.isNegative
        ? 0
        : dateTimeCreatedAt.difference(dateTimeNow).inHours;
    controller = CountdownTimerController(endTime: data, onEnd: onEnd);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        //status bar color
      ),
    );
    if (!isFirst) {
      apicall();
      isFirst = true;
    }
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.transparent,
          body: BackgroundCurvedView(
            widget: Consumer<LiveShowProvider>(
              builder: (context, data, child) {
                return Container(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 13, vertical: 22),
                    itemCount: data.getData().resData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _homeItemView(data.getData().resData[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ),
        AppConstants.progress(
           isLoading, context)
      ],
    );
  }

  _homeItemView(ResData data) {
    getTimerTime(data);

    tz.initializeTimeZones();
    var detroit = tz.getLocation('${data.timzone}');
    var now = tz.TZDateTime.now(detroit);
    var noww = tz.TZDateTime.now(detroit).toIso8601String();

    var dateTme = DateTime.now().toIso8601String();
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 14),
      child: Card(
        color: AppColors.lightBackGroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            data.thumbURL == null
                ? Container(
                    child: Image.asset(
                      "assets/images/pitchImage.png",
                      fit: BoxFit.cover,
                      height: 181,
                      width: 350,
                    ),
                  )
                : Column(
              // alignment: Alignment.bottomCenter,
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
                        child: CachedNetworkImage(
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  SpinKitThreeBounce(
                            size: 20,
                            duration: new Duration(milliseconds: 1800),
                            color: AppColors.appColor,
                          ),
                          imageUrl: "${data.thumbURL}",
                          width: double.infinity,
                          height: 185,
                          fit: BoxFit.fill,
                        ),
                      ),
                    _countDownTimer(),

                  ],
                ),
            SizedBox(
              height: 17,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text("${data.title}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
            SizedBox(
              height: 9,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,


                    children: [
                      Text(
                        "${DateFormat("EEEE, MMMM dd,yyyy").format(DateTime.parse(data.date))}",
                        style: TextStyle(
                            color: AppColors.lightTextColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      MaterialButton(
                        minWidth: 110,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(25),
                          ),
                        ),
                        onPressed: () {
                          _navigate(data);
                        },
                        color: AppColors.buttonRedColor,
                        child: Text(
                          "MODIFY",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${DateFormat("jm").format(DateTime.parse("2021-04-11 " + data.time))} (${now.timeZoneName} ${now.timeZoneOffset.toString().substring(0, 5)})",
                        style: TextStyle(
                            color: AppColors.lightTextColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      MaterialButton(
                        minWidth: 110,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(25),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoPlayer(
                                video: data,
                              ),
                            ),
                          );
                        },
                        color: AppColors.buttonRedColor,
                        child: Text(
                          "PREVIEW",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  _countDownTimer() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[200].withOpacity(0.1),

        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(15),
          bottomLeft: Radius.circular(15),
        ),
      ),
      width: MediaQuery.of(context).size.width,
      child: CountdownTimer(
        controller: controller,
        onEnd: onEnd,
        endTime: endTime,

        widgetBuilder: (_, CurrentRemainingTime time) {
          if (time == null) {
            return Text(
              '00:00:00',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white, fontSize: 12, letterSpacing: 3.57),
            );
          } else {
            return Text(
              '${time.hours?? "00"}:${time.min ?? "00"}:${time.sec ?? "00"}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                  color: Colors.white, fontSize: 19, letterSpacing: 3.57),
            );
          }
        },
      ),
    );
  }
  _navigate(ResData data) async {
    final result  = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StartShowScreen(
          liveData:data ,
        ),
      ),
    );
    if(result){
      apicall();
    }
  }
}
