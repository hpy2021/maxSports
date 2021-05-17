import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:maxsports/Constants/AppColors.dart';
import 'package:maxsports/Constants/AppConstants.dart';
import 'package:maxsports/Models/CommonResponse.dart';
import 'package:maxsports/Models/LiveShowResponse.dart';
import 'package:maxsports/Models/TimeZoneResponse.dart';
import 'package:maxsports/Providers/LiveShowProvider.dart';
import 'package:maxsports/Views/details_screen.dart';
import 'package:maxsports/Widgets/back_ground_view.dart';
import 'package:maxsports/Widgets/video_player.dart';
import 'package:provider/provider.dart';

class StartShowScreen extends StatefulWidget {
  ResData liveData;

  StartShowScreen({this.liveData});

  @override
  _StartShowScreenState createState() => _StartShowScreenState();
}

class _StartShowScreenState extends State<StartShowScreen> {
  CountdownTimerController controller;
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 0;
  DateTime dateTimeCreatedAt;

  DateTime dateTimeNow = DateTime.now();
  int remaininHours = 0;
  ResData detailsData;

  apicall() async {
    if(mounted)
      setState(() {
        isLoading = true;
      });
    Provider.of<LiveShowProvider>(context,listen: false).setContext(context);
    detailsData = await Provider.of<LiveShowProvider>(context, listen: false)
        .getLiveShowData(id: widget.liveData.id);
    _toUpdateData();
    if(mounted)
      setState(() {});
  }
  _toUpdateData(){
    dateTimeCreatedAt =
        DateTime.parse('${detailsData.date} ${detailsData.time}');
    int data = dateTimeCreatedAt.millisecondsSinceEpoch;
    print('${dateTimeCreatedAt.minute}');

    final differenceInDays = dateTimeCreatedAt.difference(dateTimeNow).inHours;
    remaininHours = dateTimeCreatedAt.difference(dateTimeNow).inHours.isNegative
        ? 0
        : dateTimeCreatedAt.difference(dateTimeNow).inHours;
    print('$differenceInDays');
    controller = CountdownTimerController(endTime: data, onEnd: onEnd);
    if(mounted)
      setState(() {
        isLoading = false;

      });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void onEnd() {
    print('onEnd');
  }

  bool isLoading = false;
  bool isFirst = false;
  _navigate() async {
    final result  = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsScreen(
          liveData: detailsData,
        ),
      ),
    );
    if(result){
      apicall();
    }
  }
  @override
  Widget build(BuildContext context) {
    // print("time $endTime");
    if(!isFirst){
      apicall();
      isFirst = true;
    }



    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.lightBackGroundColor,
          appBar: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            leading: InkWell(
              onTap: (){
                Navigator.pop(context,true);
              },
              child: Icon(
                  Platform.isIOS ?Icons.arrow_back_ios:Icons.arrow_back
              ),
            ),
            title: Text(
              "START SHOW",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              InkWell(
                onTap: (){
                  AppConstants().logout(context);
                },

                child: Image.asset(
                  "assets/images/logout.png",
                  height: 19,
                ),
              )
            ],
          ),
          body: BackgroundCurvedView(
            widget: _buildCircle(context),
          ),
        ),
        AppConstants.progress(isLoading, context)
      ],
    );
  }

  _mainBody() {
    return Column(
      children: [
        Container(
          height: 20,
          decoration: BoxDecoration(
              color: AppColors.lightTextColor, shape: BoxShape.circle),
        ),
      ],
    );
  }

  Widget _buildCircle(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 73,
          ),
          Container(
            width: 322,
            height: 322,
            child: CustomPaint(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Your show is live in',
                    style: TextStyle(color: AppColors.lightTextColor),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  CountdownTimer(
                    controller: controller,
                    onEnd: onEnd,
                    endTime: endTime,
                    widgetBuilder: (_, CurrentRemainingTime time) {
                      if (time == null) {
                        return Text(
                          '00:00:00',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 34,
                              letterSpacing: 3.57),
                        );
                      }
                      return Text(
                        '${time.hours ?? "00"}:${time.min ?? "00"}:${time.sec ?? "00"}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            letterSpacing: 3.57),
                      );
                    },
                    // textStyle: TextStyle(
                    //     color: Colors.white, fontSize: 34, ),
                    //
                    // endWidget:  Text(
                    //     '00:00:00',
                    //     style: TextStyle(
                    //         color: Colors.white, fontSize: 34, letterSpacing: 3.57),
                    //   ),
                  ),
                  // Text(
                  //   '00:15:25',
                  //   style: TextStyle(
                  //       color: Colors.white, fontSize: 34, letterSpacing: 3.57),
                  // ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    'Upcoming Fast',
                    style: TextStyle(color: AppColors.lightTextColor),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    '${remaininHours} Hours',
                    style: TextStyle(
                        color: AppColors.lightTextColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 17),
                  ),
                ],
              ),
              painter: CirclePainter(),
            ),
          ),
          SizedBox(
            height: 73,
          ),
          _changeSchedualbutton(),
          SizedBox(
            height: 46,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: _bottomButtons(
                    text: "Make Live",
                    onPressed: () {
                      _confirmationPopUp(
                          title: "Make live",
                          content: "Are you sure you want to make live?",
                          onConfirm: () {
                            Navigator.pop(context);
                            _makeLiveapicall();
                          });
                    },
                  ),
                ),
                Expanded(
                    child: _bottomButtons(
                        text: "Stop",
                        onPressed: () {
                         _confirmationPopUp(
                           title: "Stop live stream"
                               ,content: "Are you sure you want to stop live?"
                         ,onConfirm: (){
                             Navigator.pop(context);
                             _stopLiveApiCall();
                         });
                        })),
                Expanded(
                  child: _bottomButtons(
                    text: "Preview",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoPlayer(
                            video: detailsData,
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _changeSchedualbutton() {
    return MaterialButton(
      onPressed: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => DetailsScreen(
        //       liveData: detailsData,
        //     ),
        //   ),
        // );
        _navigate();
      },
      // minWidth: 201,
      padding: EdgeInsets.fromLTRB(24, 11, 24, 11),
      color: AppColors.buttonGreenColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(40),
        ),
      ),
      child: Text(
        "CHANGE SCHEDULE",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  _bottomButtons({String text, Function onPressed}) {
    return Container(
      margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
      child: MaterialButton(
        onPressed: onPressed,
        // minWidth: 201,
        padding: EdgeInsets.fromLTRB(0, 11, 0, 11),
        color: AppColors.buttonRedColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(7),
          ),
        ),
        child: Text(
          "$text",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  _makeLiveapicall() async {
    if (mounted)
      setState(() {
        isLoading = true;
      });
    Provider.of<LiveShowProvider>(context, listen: false).setContext(context);
    CommonResponse data =
        await Provider.of<LiveShowProvider>(context, listen: false)
            .makestreamlive(id: detailsData.id);
    if (mounted)
      setState(() {
        isLoading = false;
      });
    AppConstants().showToast(msg: "${data.msg}");
    // Provider.of<LiveShowProvider>(context, listen: false).setData(data);
    // print(data.length);
  }

  _stopLiveApiCall() async {
    if (mounted)
      setState(() {
        isLoading = true;
      });
    Provider.of<LiveShowProvider>(context, listen: false).setContext(context);
    CommonResponse data =
        await Provider.of<LiveShowProvider>(context, listen: false)
            .stopLiveStream(id: detailsData.id);
    if (data.result = true) {
      if (mounted)
        setState(() {
          isLoading = false;
        });
      AppConstants().showToast(msg: "Stream is stopped");
    }

    // Provider.of<LiveShowProvider>(context, listen: false).setData(data);
    // print(data.length);
  }

  _confirmationPopUp({String title, String content, Function onConfirm}) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("$title"),
            content: Text("$content"),
            actions: [
              CupertinoButton(
                onPressed: onConfirm,
                child: Text(
                  "Confirm",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              CupertinoButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel", style: TextStyle(color: Colors.white)),
              )
            ],
          );
        });
  }
}

class CirclePainter extends CustomPainter {
  final _paint = Paint()
    ..color = AppColors.lightBackGroundColor
    ..strokeWidth = 42
    // Use [PaintingStyle.fill] if you want the circle to be filled.
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawOval(
      Rect.fromLTWH(0, 0, size.width, size.height),
      _paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
