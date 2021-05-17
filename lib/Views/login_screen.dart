import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maxsports/Constants/AppColors.dart';
import 'package:maxsports/Constants/AppConstants.dart';
import 'package:maxsports/Constants/AppStrings.dart';
import 'package:maxsports/Models/LoginResponse.dart';
import 'package:maxsports/Providers/LoginProvider.dart';
import 'package:maxsports/Views/bottom_nav_bar.dart';
import 'package:maxsports/Views/shows_screen.dart';
import 'package:maxsports/Widgets/app_text_form_field.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  SharedPreferences prefs;

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
    final postMdl = Provider.of<LoginProvider>(context, listen: false);
  }

  @override
  void dispose() {
    errorController.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dataController = Provider.of<LoginProvider>(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    print("widget tree");
    return Stack(
      children: [
        Scaffold(backgroundColor: AppColors.backGroundColor, body: _body()),
        AppConstants.progress(isLoading, context)
      ],
    );
  }

  _body() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(height: 87),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              '${AppStrings.maxTeamHeader}',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 34),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 48),

          _emailTextFormField(),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              '${AppStrings.fourdigitText}',
              style: TextStyle(
                  fontSize: 18, color: Colors.white.withOpacity(0.55)),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Form(
            key: formKey,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 50),
                child: PinCodeTextField(
                  appContext: context,
                  pastedTextStyle: TextStyle(
                    color: Colors.green.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                  length: 4,
                  obscureText: false,

                  blinkWhenObscuring: true,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 60,
                    fieldWidth: 60,
                    inactiveFillColor: Colors.white10,

                    selectedFillColor: Colors.white10,
                    selectedColor: Colors.white10,
                    disabledColor: Colors.white10,
                    inactiveColor: Colors.white10,
                    activeColor: Colors.white10,
                    activeFillColor: hasError ? Colors.white10 : Colors.white10,
                  ),
                  cursorColor: Colors.white38,
                  animationDuration: Duration(milliseconds: 300),
                  enableActiveFill: true,
                  errorAnimationController: errorController,
                  controller: textEditingController,
                  keyboardType: TextInputType.number,
                  textStyle:
                      TextStyle(fontSize: 36, fontWeight: FontWeight.w600),

                  boxShadows: [
                    BoxShadow(
                      offset: Offset(0, 1),
                      color: Colors.black12,
                      blurRadius: 10,
                    )
                  ],
                  onCompleted: (v) {
                    print("Completed");
                  },
                  onChanged: (value) {
                    print(value);
                    setState(() {
                      currentText = value;
                    });
                  },
                  beforeTextPaste: (text) {
                    print("Allowing to paste $text");
                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                    return true;
                  },
                )),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
            child: ButtonTheme(
              height: 50,
              child: TextButton(
                onPressed: () async {
                  if (controller.text.isEmpty) {
                    AppConstants().showToast(msg: "Please enter the email address");
                  } else if (textEditingController.text.isEmpty) {
                    AppConstants().showToast(msg: "Please enter the pin");
                  }

                  else {
                    setState(() {
                      isLoading = true;
                    });
                    LoginResponse login =
                        await Provider.of<LoginProvider>(context, listen: false)
                            .login(pin: textEditingController.text,email: controller.text);
                    if (login.msg == "true") {
                      setState(() {
                        isLoading = false;
                      });

                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BottomNavigationBarView(
                              selectedIndex: 2,
                            ),
                          ),
                          (route) => false);
                    } else
                      {
                        AppConstants().showToast(msg: login.msg);
                        setState(() {
                          isLoading = false;
                        });
                      }
                  }
                },
                child: Center(
                  child: Text(
                    "${AppStrings.loginText}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ],
      ),
    );
  }
  TextEditingController controller = new TextEditingController();
  _emailTextFormField(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),

      child: AppTextFormField(
        controller: controller,
        obscureText: false,
        hintText: "Enter the email address",
      ),
    );
  }
}
