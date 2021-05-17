import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:maxsports/Constants/AppColors.dart';
import 'package:maxsports/Constants/AppConstants.dart';
import 'package:maxsports/Constants/AppStrings.dart';
import 'package:maxsports/Models/CommonResponse.dart';
import 'package:maxsports/Models/LiveShowResponse.dart';
import 'package:maxsports/Models/TimeZoneResponse.dart';
import 'package:maxsports/Providers/LiveShowProvider.dart';
import 'package:maxsports/Views/bottom_nav_bar.dart';
import 'package:maxsports/Widgets/back_ground_view.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class DetailsScreen extends StatefulWidget {
  ResData liveData;

  DetailsScreen({this.liveData});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  String seletectedWeekday,
      selectedTimeZone,
      selectedTime,
      selectedDate,
      serverDate,
      sendingtoServerTime;

  DateFormat serverFormate = DateFormat("Hms");
  DateFormat serverFormateDate = DateFormat("dd-MM-yyyy");
  TimeZoneResponse timeZoneResponse;
  List<String> tzData = [];
  tz.TZDateTime serverDateTime;

  TextEditingController textEditingController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  bool isLoading = false;
  ResData detailsData;

  apicall() async {
    if(mounted)
      setState(() {
        isLoading = true;

      });
    tzData = [];
    Provider.of<LiveShowProvider>(context,listen: false).setContext(context);
     detailsData =
    await Provider.of<LiveShowProvider>(context, listen: false)
        .getLiveShowData(id: widget.liveData.id);

    TimeZoneResponse data =
        await Provider.of<LiveShowProvider>(context, listen: false)
            .getTimezone();
    print("original data from api ${data.timeZoneData.length}");
    data.timeZoneData.forEach((element) {
      tzData.add(element.timezone);
    });
    print("length of the string list ${tzData.length}");


    _toUpdateData();
    setup();
if(mounted)
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

_toUpdateData(){
  textEditingController.text = detailsData.videoURL??"";
  nameController.text = detailsData.title??"";
  selectedTimeZone = detailsData.timzone== null ||detailsData.timzone== ""?"US/Central":detailsData.timzone;
  selectedDate = "${DateFormat("EEEE, MMMM dd,yyyy").format(
    DateTime.parse("${detailsData.date} ${detailsData.time}"),
  )}";
  serverDate = "${serverFormateDate.format(
    DateTime.parse("${detailsData.date} ${detailsData.time}"),
  )}";
  selectedTime = DateFormat("jm").format(
      DateTime.parse("${detailsData.date} ${detailsData.time}"),);
  seletectedWeekday = DateFormat("EEEE").format(
    DateTime.parse("${detailsData.date} ${detailsData.time}"),
  );
  if(mounted)
    setState(() {
      isLoading = false;

    });
}
  bool isFirst = false;

  Future<void> setup() async {
    tz.initializeTimeZones();
    var uscentralTime = tz.getLocation('$selectedTimeZone');
    serverDateTime = tz.TZDateTime.from(
        DateTime.parse("${detailsData.date} ${detailsData.time}"),
        uscentralTime);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if(!isFirst){
      apicall();
      isFirst = true;
    }

    // setup();

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
              "DETAILS",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              InkWell(
                onTap: () {
                  AppConstants().logout(context);
                },
                child: Image.asset(
                  "assets/images/logout.png",
                  height: 19,
                ),
              ),
            ],
          ),
          body: _mainBody(),
        ),
        AppConstants.progress(isLoading, context)
      ],
    );
  }

  _mainBody() {
    return BackgroundCurvedView(
      widget: Container(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 17),
          child: detailsData == null ? Container():_dataBody()),
    );
  }

  _dataBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _titleRow(),
          SizedBox(
            height: 23,
          ),
          _timeAndDateRow(),
          SizedBox(
            height: 49,
          ),
          _commonViewOfRow("Name", 2, nameController),
          SizedBox(
            height: 15,
          ),
          _commonViewOfRow("URl", 5, textEditingController),
          SizedBox(
            height: 15,
          ),

          _dateDropDown(),

          SizedBox(
            height: 15,
          ),
          _timeDropDown(),
          // _commonViewOfRow("data", 1),
          SizedBox(
            height: 15,
          ),
          _timezoneDropDown(),

          SizedBox(
            height: 58,
          ),
          _bottomButton()
        ],
      ),
    );
  }

  _dateDropDown() {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.height * 0.15,
          child: Text("Date : "),
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              _datePicker();
            },
            child: Container(
              decoration: BoxDecoration(
                  color: AppColors.lightBackGroundColor,
                  borderRadius: BorderRadius.circular(5)),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 13),
              child: Row(
                children: [
                  Expanded(child: Text("$selectedDate")),
                  Icon(Icons.arrow_drop_down)
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  _datePicker() {
    DatePicker.showDatePicker(context, showTitleActions: true,
        theme: DatePickerTheme(
          backgroundColor: Colors.white
        ),
        onChanged: (date) {
      selectedDate = "${DateFormat("EEEE, MMMM dd,yyyy").format(
        DateTime.parse("$date"),
      )}";
      serverDate = "${serverFormateDate.format(
        DateTime.parse("$date"),
      )}";
      if (mounted) setState(() {});
    }, onConfirm: (date) {
    }, currentTime: DateTime.now());
  }

  _titleRow() {
    return Row(
      children: [
        Expanded(
          child: Text(
            "${detailsData.title??""}",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(
          width: 21,
        ),
      ],
    );
  }

  _timeAndDateRow() {
    tz.initializeTimeZones();
    var detroit = tz.getLocation('$selectedTimeZone');
    var now = tz.TZDateTime.now(detroit);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${DateFormat("EEEE, MMMM dd,yyyy").format(
              DateTime.parse("${detailsData.date??""} ${detailsData.time??""}"),
            )}",
            style: TextStyle(
                color: AppColors.lightTextColor,
                fontSize: 14,
                fontWeight: FontWeight.w400),
          ),
          RichText(
            text: TextSpan(
                text: "${DateFormat("jm").format(
                  DateTime.parse(
                      "${detailsData.date??""} ${detailsData.time??""}"),
                )}",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w300),
                children: [
                  TextSpan(
                      text:
                          " (${now.timeZoneName} ${now.timeZoneOffset.toString().substring(0, 5)})",
                      style: TextStyle(
                          color: AppColors.lightTextColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w300))
                  // ${DateFormat("jm").format(DateTime.parse("2021-04-11 " + "20:00:00"))
                ]),
            // "${DateFormat("jm").format(DateTime.parse("2021-04-11 " + "20:00:00"))} (${now.timeZoneName} ${now.timeZoneOffset.toString().substring(0 , 5)})",
          ),
        ],
      ),
    );
  }

  _commonViewOfRow(
      String text, int maxLength, TextEditingController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.height * 0.15,
          child: Text("$text : "),
        ),
        Expanded(
          flex: 1,
          child: _textFormField(maxLength, controller),
        )
      ],
    );
  }

  _textFormField(int maxLength, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      maxLines: maxLength,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
        fillColor: AppColors.lightBackGroundColor,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
      ),
    );
  }

  _timeDropDown() {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.height * 0.15,
          child: Text("Time : "),
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              _selectTime();
            },
            child: Container(
              decoration: BoxDecoration(
                  color: AppColors.lightBackGroundColor,
                  borderRadius: BorderRadius.circular(5)),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 13),
              child: Row(
                children: [
                  Expanded(child: Text("$selectedTime")),
                  Icon(Icons.arrow_drop_down)
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _selectTime() async {
    DatePicker.showTimePicker(context, showTitleActions: true,
        theme: DatePickerTheme(
            backgroundColor: Colors.white

        ),
        onChanged: (date) {
      selectedTime = DateFormat("jm").format(DateTime.parse("$date"));
      tz.initializeTimeZones();
      var uscentralTime = tz.getLocation('$selectedTimeZone');
      serverDateTime = tz.TZDateTime.from(date, uscentralTime);

      setState(() {});
    }, onConfirm: (date) {
      print('confirm $date');
    },
        currentTime:
            DateTime.parse("${detailsData.date??"2021-04-22"} ${detailsData.time??"00:00:00"}"));
  }

  _timezoneDropDown() {
    print("this is the selected timeZone $selectedTimeZone");
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.height * 0.15,
          child: Text("TimeZone : "),
        ),
        Expanded(
          child: Container(
            child: DropdownButtonFormField(
              isExpanded: true,
              decoration: InputDecoration(
                filled: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                fillColor: AppColors.lightBackGroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
              ),
              value: selectedTimeZone ?? "US/Central",
              onChanged: (val) {
                selectedTimeZone = val;
                if(mounted)
                setState(() {});
              },
              items: tzData.map<DropdownMenuItem>((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  String selectedtime;

  _bottomButton() {
    return Container(
        child: MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      padding: EdgeInsets.symmetric(vertical: 11, horizontal: 70),
      color: AppColors.buttonRedColor,
      onPressed: () {
        selectedtime =
            "${serverDateTime.hour}:${serverDateTime.minute}:${serverDateTime.second}";
        _validation();

      },
      child: Text(
        "Update".toUpperCase(),
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
      ),
    ));
  }

  _validation() {
    if (nameController.text.trim().isEmpty) {
      AppConstants().showToast(msg: "Please enter the name");
    } else if (serverDate == "" || serverDate == null) {
      AppConstants().showToast(msg: "Please select the date");
    } else if (selectedtime == "" || selectedtime == null) {
      AppConstants().showToast(msg: "Please select the time");
    } else if (selectedTimeZone == "" || selectedTimeZone == null) {
      AppConstants().showToast(msg: "Please select the timeZone");
    } else {
      _updateDetails(
          id: detailsData.id,
          title: nameController.text,
          date: serverDate,
          time: "$selectedtime",
          customMsg: "Live",
          timeZone: selectedTimeZone);
    }
  }

  _updateDetails(
      {String id,
      String title,
      String date,
      String time,
      String customMsg,
      String timeZone}) async {
    if (mounted)
      setState(() {
        isLoading = true;
      });

    Provider.of<LiveShowProvider>(context, listen: false).setContext(context);
    CommonResponse data =
        await Provider.of<LiveShowProvider>(context, listen: false)
            .updateShowDetail(
                id: id,
                title: title,
                date: date,
                time: time,
                customMsg: customMsg,
                timeZone: timeZone);
    if (data.result == true) {
      if (mounted)
        setState(() {
          isLoading = true;
        });

      apicall();
      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => BottomNavigationBarView(
      //               selectedIndex: 2
      //             )),
      //     (route) => false);
      AppConstants().showToast2(msg: "Updated successfully",context: context);
    } else {
      if (mounted)
        setState(() {
          isLoading = true;
        });
    }
  }
}
