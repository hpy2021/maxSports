import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maxsports/Constants/AppColors.dart';
import 'package:maxsports/Models/LiveShowResponse.dart';
import 'package:maxsports/Widgets/app_text_form_field.dart';

class UpdateShowScreen extends StatelessWidget {
  ResData resData;

  UpdateShowScreen({@required this.resData});

  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = new TextEditingController();
  TextEditingController timeController = new TextEditingController();
  TextEditingController dateController = new TextEditingController();
  TextEditingController isLiveController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        title: Text(
          "Update Data",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        actionsIconTheme: IconThemeData(color: Colors.black),
      ),
      body: _mainBody(),
    );
  }

  _mainBody() {
    return Container(padding: EdgeInsets.all(20), child: _fields());
  }

  _fields() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          AppTextFormField(
            controller: titleController,
            hintText: "Title",
            obscureText: false,
            validator: (value) {
              if (value.isEmpty) {
                return "Please fill in the value";
              }
              return null;
            },
          ),
          SizedBox(
            height: 15,
          ),
          AppTextFormField(
            controller: timeController,
            hintText: "Time",
            obscureText: false,
            validator: (value) {
              if (value.isEmpty) {
                return "Please fill in the value";
              }
              return null;
            },
          ),
          SizedBox(
            height: 15,
          ),
          AppTextFormField(
            controller: dateController,
            hintText: "Date",
            obscureText: false,
            validator: (value) {
              if (value.isEmpty) {
                return "Please fill in the value";
              }
              return null;
            },
          ),
          Expanded(
            child: SizedBox(
              height: 15,
            ),
          ),
          Container(
            width: double.infinity,
            child: CupertinoButton(
              color: AppColors.appColor,
              padding: EdgeInsets.all(5),
              // minSize: 100,

              child: Text("Update"), onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}
